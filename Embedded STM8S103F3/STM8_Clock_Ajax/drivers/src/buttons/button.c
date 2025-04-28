/**
 * @file button.c
 * @brief Button interrupt library for STM8S103 (PC3 and PD2)
 *
 * @author Denys Navrotskyi <navrotskyi@kai.edu.ua>
 * @date 2024–2025
 * @version 1.0
 *
 * @details
 * This library implements interrupt-driven handling of two user buttons
 * connected to GPIO pins PC3 and PD2 of the STM8S103F3 microcontroller.
 *
 * Buttons must be connected with external 10kΩ pull-down resistors.
 * The system uses hardware EXTI (external interrupts) with rising edge trigger,
 * activated on button press (logic 0 → 1).
 *
 * Features:
 * - Initialization of GPIO and EXTI for each button
 * - Debounce logic by waiting for button release
 * - Manual control of interrupt enable/disable per pin
 * - Safety “watchdog” logic that automatically re-enables EXTI if needed
 *
 * Interrupt Configuration:
 * - PC3 triggers EXTI via EXTI_CR1[5:4] (bits 4–5)
 * - PD2 triggers EXTI via EXTI_CR2 bit 2
 * - EXTI is triggered on **rising edge**
 *
 * Usage:
 * 1. Call Buttons_Init() at startup.
 * 2. Use Button_HourPressed() / Button_MinutePressed() to detect events (set by ISR).
 * 3. In main loop, wait for release, debounce, then re-enable EXTI manually.
 * 4. Optionally, call Button_Hour_EnsureInterruptEnabled() to auto-recover from missed ISR triggers.
 *
 * Example:
 *     Buttons_Init();
 *     while (1)
 *     {
 *         if (Button_HourPressed()) {
 *             // your logic here
 *         }
 *     }
 */

// =============================================================================
//     Includes
// =============================================================================
#include "iostm8s103.h"
#include "button.h"

// =============================================================================
//     Defines
// =============================================================================
#define BTN_HOUR_PIN 3 // PC3
#define BTN_MIN_PIN 2  // PD2

// =============================================================================
//     Global Variables
// =============================================================================
volatile uint8_t flag_hour = 0;
volatile uint8_t flag_min = 0;

// ============================================================================
//     Public API functions
// ============================================================================
void Buttons_Init(void)
{
    // === PC3 (Hour button) ===
    PC_DDR &= ~(1 << BTN_HOUR_PIN); // input mode
    PC_CR1 &= ~(1 << BTN_HOUR_PIN); // no pull-up (external pull-down used)
    PC_CR2 |= (1 << BTN_HOUR_PIN);  // enable EXTI on PC3

    // EXTI_CR1[5:4] = 01 → rising edge for PORTC (PC3)
    EXTI_CR1 = (EXTI_CR1 & ~(3 << 4)) | (1 << 4);

    // === PD2 (Minute button) ===
    PD_DDR &= ~(1 << BTN_MIN_PIN); // input mode
    PD_CR1 &= ~(1 << BTN_MIN_PIN); // no pull-up (external pull-down used)
    PD_CR2 |= (1 << BTN_MIN_PIN);  // enable EXTI on PD2

    // EXTI_CR1[7:6] = 01 → rising edge for PORTD (?PD2)
    EXTI_CR1 = (EXTI_CR1 & ~(3 << 6)) | (1 << 6);

    // EXTI_CR2 bit 2 = 1 → rising edge for PD2
    EXTI_CR2 |= (1 << 2);
    // EXTI_CR1 &= ~(1 << 7); //PORTD FALLING & LOW Level
    // EXTI_CR1 |= (1 << 6); //PORTD FALLING & LOW Level
}

uint8_t Button_HourPressed(void)
{
    uint8_t result = flag_hour;
    flag_hour = 0;
    return result;
}

uint8_t Button_MinutePressed(void)
{
    uint8_t result = flag_min;
    flag_min = 0;
    return result;
}

void Button_Minute_EnableInterrupt(void)
{
    PD_CR2 |= (1 << BTN_MIN_PIN); // Enable EXTI on PD2
}

void Button_Minute_DisableInterrupt(void)
{
    PD_CR2 &= ~(1 << BTN_MIN_PIN); // Disable EXTI on PD2
}

void Button_Hour_EnableInterrupt(void)
{
    PC_CR2 |= (1 << BTN_HOUR_PIN); // Enable EXTI on PC3
}

void Button_Hour_DisableInterrupt(void)
{
    PC_CR2 &= ~(1 << BTN_HOUR_PIN); // Disable EXTI on PC3
}

void Button_Hour_WaitRelease(void)
{
    while (PC_IDR & (1 << BTN_HOUR_PIN))
        ; // Wait for LOW
}

void Button_Minute_WaitRelease(void)
{
    while (PD_IDR & (1 << BTN_MIN_PIN))
        ; // Wait for LOW
}

uint8_t Button_BothPressed_FirstMinute_SecondHour_WaitRelease(void)
{
    while (PD_IDR & (1 << BTN_MIN_PIN)) // Wait for LOW, while HIGH
    {
        if (PC_IDR & (1 << BTN_HOUR_PIN)) // if HIGH
        {
            return 1;
        }
    }
    return 0;
}

uint8_t Button_BothPressed_FirstHour_SecondMinut_WaitRelease(void)
{
    while (PC_IDR & (1 << BTN_HOUR_PIN)) // Wait for LOW, while HIGH
    {
        if (PD_IDR & (1 << BTN_MIN_PIN)) // if HIGH
        {
            return 1;
        }
    }
    return 0;
}

uint8_t Button_BothReleased(void)
{
    if (!(PC_IDR & (1 << BTN_HOUR_PIN)) && !(PD_IDR & (1 << BTN_MIN_PIN)))
    {
        return 1;
    }
    return 0;
}

// ============================================================================
// === Watchdog Safety Functions ==============================================
// ============================================================================
void Button_Hour_EnsureInterruptEnabled(void)
{
    if (!(PC_IDR & (1 << BTN_HOUR_PIN))) // якщо LOW — кнопка не натиснута
    {
        Button_Hour_EnableInterrupt();
    }
}

void Button_Minute_EnsureInterruptEnabled(void)
{
    if (!(PD_IDR & (1 << BTN_MIN_PIN))) // LOW = не натиснута
    {
        Button_Minute_EnableInterrupt();
    }
}

// ============================================================================
// === Interrupt Service Routines =============================================
// ============================================================================
/**
 * @brief External interrupt handler for Hour button (PC3).
 *
 * Triggered by a rising edge on PC3 (EXTI line).
 * When the button is pressed, it sets a flag and disables further EXTI
 * until manually re-enabled.
 *
 * @note This handler is linked via the interrupt vector table in
 *       `stm8_interrupt_vector.c` as IRQ5.
 *
 * @see Button_HourPressed()
 * @see Button_Hour_DisableInterrupt()
 * @see stm8_interrupt_vector.c — interrupt vector table definition
 */
@far @interrupt void EXTI_PORTC_IRQHandler(void)
{
    // if (!(PC_IDR & (1 << BTN_HOUR_PIN))) // check if still low (pressed)
    if (PC_IDR & (1 << BTN_HOUR_PIN))
    {
        flag_hour = 1;
        Button_Hour_DisableInterrupt();
    }
}

/**
 * @brief External interrupt handler for Minute button (PD2).
 *
 * Triggered by a rising edge on PD2 (EXTI line).
 * When the button is pressed, it sets a flag and disables further EXTI
 * until manually re-enabled in the main loop.
 *
 * @note This handler is linked via the interrupt vector table in
 *       `stm8_interrupt_vector.c` as IRQ6.
 *
 * @see Button_MinutePressed()
 * @see Button_Minute_DisableInterrupt()
 * @see stm8_interrupt_vector.c — interrupt vector table definition
 */
@far @interrupt void EXTI_PORTD_IRQHandler(void)
{
    // if (!(PD_IDR & (1 << BTN_MIN_PIN))) // check if still low (pressed)
    if (PD_IDR & (1 << BTN_MIN_PIN))
    {
        flag_min = 1;
        Button_Minute_DisableInterrupt();
    }
}
