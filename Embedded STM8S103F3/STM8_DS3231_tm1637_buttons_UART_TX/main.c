/**
 * @file main.c
 * @brief Digital clock firmware with time display, editing, and user interaction using STM8S103.
 *
 * @author Denys Navrotskyi <navrotskyi@kai.edu.ua>
 * @date 2024–2025
 * @version 1.0
 *
 * @details
 * This is the main control file of the STM8S103-based digital clock firmware.
 * The project integrates DS3231 (RTC) and TM1637 (LED display) and supports user interaction through two buttons.
 *
 * ## Features:
 * - Time synchronization from DS3231 via I2C
 * - Time display using TM1637-controlled 7-segment 4-digit LED display
 * - UART debug output at 9600 baud (TX = PD5)
 * - Button input via external interrupts on PC3 (Hour) and PD2 (Minute)
 * - Support for real-time clock editing via user input
 * - Protection against accidental button presses using debouncing and interrupt gating
 * - Auto-disable and re-enable of interrupts for stable operation
 * - Watchdog-style polling fallback to re-enable missed interrupts
 *
 * ## User Interaction:
 * 1. **Accidental Press Protection:**
 *    Each button press is confirmed by checking pin state to avoid false triggers.
 *
 * 2. **Entering/Exiting Time Edit Mode:**
 *    When both buttons (PC3 and PD2) are pressed simultaneously, the device enters time edit mode.
 *    Pressing both buttons again exits edit mode and saves the new time to the DS3231.
 *
 * 3. **Time Editing:**
 *    While in edit mode, pressing the Minute button (PD2) increases the minutes,
 *    and pressing the Hour button (PC3) increases the hours.
 *    Buttons are debounced and become sensitive to each individual press.
 *
 * ## MCU Configuration:
 * - Clock: 16 MHz internal (HSI)
 * - UART1: TX only, PD5, 9600 baud
 * - I2C: PB4 (SCL), PB5 (SDA) for DS3231
 * - TM1637 Display: PC5 (CLK), PC6 (DIO)
 * - Buttons: PC3 (Hour), PD2 (Minute) with external pull-down (10kΩ)
 *
 * @note
 * The design assumes external pull-down resistors for buttons.
 * Interrupts are managed to prevent bouncing and edge glitches.
 *
 * @todo
 * Refactor delay_ms() to use hardware timer for more accurate delays.
 */

// =============================================================================
//                              INCLUDES
// =============================================================================
#include "iostm8s103.h"
#include "ds3231Time.h"
#include "tm1637.h"
#include "uartTX.h"
#include "button.h"

// =============================================================================
//                              DEFINES
// =============================================================================
#define RTC_BUF_SIZE 3
#define HOURS_IN_DAY 24
#define MINUTES_IN_HOUR 60

// =============================================================================
//                         STATIC GLOBAL VARIABLES
// =============================================================================
static uint8_t rtc_buf[RTC_BUF_SIZE];
static uint8_t hours = 0, min = 0, secs = 0;
static const uint8_t displayWaitIndicator[8] = {' ', ' ', ':', ' ', ' ', '\0'};
static uint8_t is_setting_time = 0;

// =============================================================================
//                         FUNCTION DECLARATIONS
// =============================================================================
static void init_hardware(void);
static void CLK_init(void);
static void delay_ms(uint16_t ms);
static void update_display_time(void);
static void handle_hour_button(void);
static void handle_minute_button(void);
static void uart_write_hex(uint8_t val);
static uint8_t bcd_to_dec(uint8_t bcd);
static uint8_t dec_to_bcd(uint8_t dec);
static void toggle_time_setting_mode(void);
static void set_time(void);
static void sync_time_from_ds3231(void);
static void ds3231_read_raw_time(void);
static void rtc_reorder_bytes(void);
static void log_time_over_uart(void);

// =============================================================================
//                                  MAIN
// =============================================================================
void main(void)
{
    init_hardware();

    tm1637SetBrightness(1);

    uart_write("Test\r\n");
    delay_ms(100);

    _asm("rim"); // ← Important! Enable global interrupts
    // #asm
    // rim
    // #endasm

    while (1)
    {
        handle_hour_button();

        handle_minute_button();

        if (Button_BothReleased())
        {
            if (!is_setting_time)
            {
                sync_time_from_ds3231();
            }

            update_display_time();
        }

        // Watchdog-style recovery for EXTI — re-enables interrupts if stuck
        Button_Hour_EnsureInterruptEnabled();
        Button_Minute_EnsureInterruptEnabled();
    }
}

// =============================================================================
//                         FUNCTION DEFINITIONS
// =============================================================================

/**
 * @brief Delay function with software loop.
 *
 * @param ms Number of milliseconds to delay. Approximate based on 16 MHz CPU.
 * @note This is a blocking delay
 * @note
 * The delay is not cycle-accurate. It was empirically tested to work
 * reliably with the current application logic (STM8 @ 16 MHz).
 *
 * @bug
 * Timing may drift if core frequency is changed or function logic is modified.
 * Any change in this function may require re-tuning delay-dependent parts of the system.
 *
 * @todo
 * Replace with a hardware timer-based implementation if precise timing is required.
 */
static void delay_ms(uint16_t ms)
{
    volatile uint16_t i;

    while (ms--)
    {
        for (i = 0; i < 1600; i++)
        {
            __asm("nop");
        }
    }
}

/**
 * @brief Initialize system clock to 16 MHz using internal HSI oscillator.
 */
static void CLK_init()
{
    CLK_SWR = 0xE1;      // select HSI as the clock source
    CLK_SWCR = (1 << 1); // enable switching (SWEN = 1)
    while (CLK_CMSR != 0xE1)
        ;              // wait until HSI becomes the active clock source
    CLK_CKDIVR = 0x00; // set HSI divider = 1, CPU divider = 1
    // CLK_PCKENR1 = 0xFF;    // enable clock for all peripherals connected to PCKENR1 bus (UART1, SPI, TIM1, TIM2, TIM3)
}

/**
 * @brief Initialize all peripherals: clock, UART, TM1637 display, I2C, buttons.
 */
static void init_hardware()
{
    CLK_init();

    // Initialize TM1637 clock and data pins (PC5 and PC6)
    tm1637Init(); // PC5 (CLK), PC6 (DIO)

    // Initialize UART and buttons
    uart_init();    // TX only, PD5, 9600 baud
    Buttons_Init(); // PC3 and PD2

    // Initialize I2C (SDA: PB5, SCL: PB4)
    I2CInit(); // PB4 (SCL), PB5 (SDA) for DS3231
}

/**
 * @brief Sends a byte value as a 2-character hexadecimal string over UART.
 *
 * @details
 * Converts an 8-bit unsigned integer into a null-terminated string
 * containing two hexadecimal characters (uppercase), then sends this
 * string via the UART interface using `uart_write()`.
 *
 * For example, if `val = 0x3F`, the function sends the string `"3F"`.
 *
 * @param val The byte value (0–255) to convert and send over UART.
 * @note This is a debug function, use only for diagnostics
 */
static void uart_write_hex(uint8_t val)
{
    char hex[3];
    static const char *hex_digits = "0123456789ABCDEF";
    hex[0] = hex_digits[(val >> 4) & 0x0F];
    hex[1] = hex_digits[val & 0x0F];
    hex[2] = '\0';
    uart_write(hex);
}

// Декодування BCD → decimal
// BCD (Binary Coded Decimal) — це спосіб зберігання десяткових цифр, де кожна цифра (0–9) кодується окремо в 4 біти.
// DS3231 має I2C-інтерфейс і надає час у форматі BCD. Перші 3 байти в регістрах — це: sec, min, hour + flag AM/PM
/**
 * @brief Convert BCD-encoded value to decimal.
 *
 * @param bcd BCD-encoded byte
 * @return Decimal value
 */
static uint8_t bcd_to_dec(uint8_t bcd)
{
    return ((bcd >> 4) * 10) + (bcd & 0x0F);
}

// Конверсія назад: Decimal → BCD
// Щоб записати значення у DS3231
/**
 * @brief Convert decimal value to BCD encoding.
 *
 * @param dec Decimal value (0–99)
 * @return BCD-encoded byte
 */
static uint8_t dec_to_bcd(uint8_t dec)
{
    return ((dec / 10) << 4) | (dec % 10);
}

/**
 * @brief Update the TM1637 display with the current time.
 *
 * Shows blinking colon every second.
 */
static void update_display_time()
{
    static uint8_t displayBuffer[8];

    if (secs & 1)
    {
        displayBuffer[0] = '0' + hours / 10;
        displayBuffer[1] = '0' + hours % 10;
        displayBuffer[2] = ':';
        displayBuffer[3] = '0' + min / 10;
        displayBuffer[4] = '0' + min % 10;
        displayBuffer[5] = '\0';
    }
    else
    {
        displayBuffer[0] = '0' + hours / 10;
        displayBuffer[1] = '0' + hours % 10;
        displayBuffer[2] = ' ';
        displayBuffer[3] = '0' + min / 10;
        displayBuffer[4] = '0' + min % 10;
        displayBuffer[5] = '\0';
    }
    tm1637ShowDigits(displayBuffer);
}

/**
 * @brief Handle logic for when the Hour button is pressed.
 *
 * Increments hour or reacts to simultaneous press of both buttons
 * (first Hour, then Minute).
 */
static void handle_hour_button()
{
    if (Button_HourPressed())
    {
        delay_ms(100); // debounce

        if (Button_BothPressed_FirstHour_SecondMinut_WaitRelease())
        {
            uart_write("Both buttons are pressed after Hour button\r\n");
            toggle_time_setting_mode();
            tm1637ShowDigits(displayWaitIndicator);

            // Wait for Minute button release after dual press
            Button_Minute_WaitRelease();
            Button_MinutePressed(); // clear flag if still set
            delay_ms(100);          // debounce
            Button_Minute_EnableInterrupt();
        }
        else
        {
            uart_write("Hour button pressed\r\n");

            if (is_setting_time)
            {
                hours++;
                hours %= HOURS_IN_DAY;
            }
        }

        Button_Hour_WaitRelease();     // wait for button release
        delay_ms(100);                 // debounce
        Button_Hour_EnableInterrupt(); // re-enable interrupt

#ifdef DEBUG
        uart_write("re-enabled interrupt Hour\r\n");
#endif
    }
}

/**
 * @brief Handle logic for when the Minute button is pressed.
 *
 * Increments minutes or reacts to simultaneous press of both buttons
 * (first Minute, then Hour).
 */
static void handle_minute_button()
{
    if (Button_MinutePressed())
    {
        delay_ms(100); // debounce

        if (Button_BothPressed_FirstMinute_SecondHour_WaitRelease())
        {
            uart_write("Both buttons are pressed after Min button\r\n");
            toggle_time_setting_mode();
            tm1637ShowDigits(displayWaitIndicator);

            // Wait for Hour button release after dual press
            Button_Hour_WaitRelease();
            Button_HourPressed(); // clear flag if still set
            delay_ms(100);        // debounce
            Button_Hour_EnableInterrupt();
        }
        else
        {
            uart_write("Minute button pressed\r\n");

            if (is_setting_time)
            {
                min++;
                min %= MINUTES_IN_HOUR;
            }
        }

        Button_Minute_WaitRelease();     // wait for button release
        delay_ms(100);                   // debounce
        Button_Minute_EnableInterrupt(); // re-enable interrupt

#ifdef DEBUG
        uart_write("re-enabled interrupt Min\r\n");
#endif
    }
}

/**
 * @brief Toggle the time setting mode flag.
 *
 * If entering time setting mode:
 *   - Set seconds to 0
 *   - Increase display brightness
 *
 * If exiting time setting mode:
 *   - Save adjusted time to DS3231
 *   - Restore normal brightness
 */
static void toggle_time_setting_mode(void)
{
    is_setting_time = !is_setting_time;
    if (is_setting_time)
    {
        secs = 0;
        tm1637SetBrightness(8);
    }
    if (!is_setting_time)
    {
        set_time();
        tm1637SetBrightness(1);
    }
}

/**
 * @brief Write the current time to DS3231 after converting from decimal to BCD.
 *
 * This function is called when exiting time setting mode.
 */
static void set_time()
{
    uint8_t hours_bcd = dec_to_bcd(hours);
    uint8_t minutes_bcd = dec_to_bcd(min);
    uint8_t seconds_bcd = dec_to_bcd(secs);
    DS3231_SetTimeManual(hours_bcd, minutes_bcd, seconds_bcd);
}

/**
 * @brief Reads time from DS3231 and loads it into the global `hours`, `min`, `secs`.
 */
static void sync_time_from_ds3231(void)
{
    ds3231_read_raw_time();
    rtc_reorder_bytes();
    log_time_over_uart();

    hours = bcd_to_dec(rtc_buf[0]);
    min = bcd_to_dec(rtc_buf[1]);
    secs = bcd_to_dec(rtc_buf[2]);
}

/**
 * @brief Read raw time bytes from DS3231 into rtc_buf.
 */
static void ds3231_read_raw_time(void)
{
    DS3231_GetTime(rtc_buf, RTC_BUF_SIZE);
}

/**
 * @brief Reorder rtc_buf so that hours is at index 0.
 */
static void rtc_reorder_bytes(void)
{
    static uint8_t tmp;

    tmp = rtc_buf[0];
    rtc_buf[0] = rtc_buf[2];
    rtc_buf[2] = tmp;
}

/**
 * @brief Print time to UART in hex format (HH:MM:SS).
 */
static void log_time_over_uart(void)
{
    uart_write("Time: ");
    uart_write_hex(rtc_buf[0]);
    uart_write(":");
    uart_write_hex(rtc_buf[1]);
    uart_write(":");
    uart_write_hex(rtc_buf[2]);
    uart_write("\r\n");
}
