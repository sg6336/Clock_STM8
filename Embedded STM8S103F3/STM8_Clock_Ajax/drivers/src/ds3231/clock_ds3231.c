// =============================================================================
//     Includes
// =============================================================================
#include "clock.h"
#include "ds3231time.h"
#include "logger.h"

// =============================================================================
//     Defines
// =============================================================================
#define RTC_BUF_SIZE 3

// =============================================================================
//     Global Variables
// =============================================================================
volatile ClockTime current_time;

// =============================================================================
//     Static Variables
// =============================================================================
static uint8_t hours;
static uint8_t min;
static uint8_t secs;
static uint8_t rtc_buf[RTC_BUF_SIZE];

// =============================================================================
//     Static Function Prototypes
// =============================================================================
static void _set_time(void);
static void _sync_time_from_ds3231(void);
static void _ds3231_read_raw_time(void);
static void _rtc_reorder_bytes(void);
static void _log_time_over_uart(void);
static void _uart_write_hex(uint8_t val);
static uint8_t _bcd_to_dec(uint8_t bcd);
static uint8_t _dec_to_bcd(uint8_t dec);

// ============================================================================
//     Public API functions
// ============================================================================
void clock_init(void) // Initialize I2C (SDA: PB5, SCL: PB4) for DS3231
{
    // Initialize I2C (SDA: PB5, SCL: PB4)
    I2CInit(); // PB4 (SCL), PB5 (SDA) for DS3231
}

void get_time_from_clock(void)
{
    _sync_time_from_ds3231();
}

void set_time_to_clock(/* uint8_t hours, uint8_t min, uint8_t secs */)
{
    _set_time();
}

void add_one_minute(void)
{
    current_time.minutes++;
    current_time.minutes %= MINUTES_IN_HOUR;
}

void add_one_hour(void)
{
    current_time.hours++;
    current_time.hours %= HOURS_IN_DAY;
}

// ============================================================================
//     Static internal functions
// ============================================================================
/**
 * @brief Write the current time to DS3231 after converting from decimal to BCD.
 *
 * This function is called when exiting time setting mode.
 */
static void _set_time()
{
    uint8_t hours_bcd;
    uint8_t minutes_bcd;
    uint8_t seconds_bcd;

    hours = current_time.hours;
    min = current_time.minutes;
    secs = current_time.seconds;

    hours_bcd = _dec_to_bcd(hours);
    minutes_bcd = _dec_to_bcd(min);
    seconds_bcd = _dec_to_bcd(secs);
    DS3231_SetTimeManual(hours_bcd, minutes_bcd, seconds_bcd);
}

/**
 * @brief Reads time from DS3231 and loads it into the global `hours`, `min`, `secs`.
 */
static void _sync_time_from_ds3231(void)
{
    _ds3231_read_raw_time();
    _rtc_reorder_bytes();
    _log_time_over_uart();

    hours = _bcd_to_dec(rtc_buf[0]);
    min = _bcd_to_dec(rtc_buf[1]);
    secs = _bcd_to_dec(rtc_buf[2]);

    current_time.hours = hours;
    current_time.minutes = min;
    current_time.seconds = secs;
}

/**
 * @brief Read raw time bytes from DS3231 into rtc_buf.
 */
static void _ds3231_read_raw_time(void)
{
    DS3231_GetTime(rtc_buf, RTC_BUF_SIZE);
}

/**
 * @brief Reorder rtc_buf so that hours is at index 0.
 */
static void _rtc_reorder_bytes(void)
{
    static uint8_t tmp;

    tmp = rtc_buf[0];
    rtc_buf[0] = rtc_buf[2];
    rtc_buf[2] = tmp;
}

/**
 * @brief Print time to UART in hex format (HH:MM:SS).
 */
static void _log_time_over_uart(void)
{
    logger_write("Time: ");
    _uart_write_hex(rtc_buf[0]);
    logger_write(":");
    _uart_write_hex(rtc_buf[1]);
    logger_write(":");
    _uart_write_hex(rtc_buf[2]);
    logger_write("\r\n");
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
static void _uart_write_hex(uint8_t val)
{
    char hex[3];
    static const char *hex_digits = "0123456789ABCDEF";
    hex[0] = hex_digits[(val >> 4) & 0x0F];
    hex[1] = hex_digits[val & 0x0F];
    hex[2] = '\0';
    logger_write(hex);
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
static uint8_t _bcd_to_dec(uint8_t bcd)
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
static uint8_t _dec_to_bcd(uint8_t dec)
{
    return ((dec / 10) << 4) | (dec % 10);
}
