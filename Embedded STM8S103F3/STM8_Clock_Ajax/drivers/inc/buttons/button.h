/**
 * @file button.h
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

#ifndef BUTTON_H
#define BUTTON_H

#include <stdint.h>

/**
 * @brief Initialize GPIO and EXTI for both buttons.
 *
 * Configures PC3 and PD2 as inputs with interrupts enabled on falling edge.
 */
void Buttons_Init(void);

/**
 * @brief Checks if the hour button (PC3) was just pressed.
 *
 * This function returns 1 only once per press (edge-triggered) and resets the flag.
 *
 * @return 1 if the hour button was pressed, 0 otherwise.
 */
uint8_t Button_HourPressed(void);

/**
 * @brief Checks if the minute button (PD2) was just pressed.
 *
 * This function returns 1 only once per press (edge-triggered) and resets the flag.
 *
 * @return 1 if the minute button was pressed, 0 otherwise.
 */
uint8_t Button_MinutePressed(void);

/**
 * @brief Enable external interrupt for the Minute button (PD2).
 */
void Button_Minute_EnableInterrupt(void);

/**
 * @brief Disable external interrupt for the Minute button (PD2).
 */
void Button_Minute_DisableInterrupt(void);

/**
 * @brief Enable external interrupt for the Hour button (PC3).
 */
void Button_Hour_EnableInterrupt(void);

/**
 * @brief Disable external interrupt for the Hour button (PC3).
 */
void Button_Hour_DisableInterrupt(void);

/**
 * @brief Wait until the Hour button is released (PC3 goes LOW).
 */
void Button_Hour_WaitRelease(void);

/**
 * @brief Wait until the Minute button is released (PD2 goes LOW).
 */
void Button_Minute_WaitRelease(void);

/**
 * @brief Waits for both buttons to be pressed: first Minute (PD2), then Hour (PC3).
 *
 * This function checks that the Minute button (PD2) is pressed first,
 * and only then the Hour button (PC3). Once both are pressed in this order,
 * it waits until both are released.
 *
 * @return 1 if both buttons were pressed in this sequence, 0 otherwise.
 */
uint8_t Button_BothPressed_FirstMinute_SecondHour_WaitRelease(void);

/**
 * @brief Waits for both buttons to be pressed: first Hour (PC3), then Minute (PD2).
 *
 * This function checks that the Hour button (PC3) is pressed first,
 * and only then the Minute button (PD2). Once both are pressed in this order,
 * it waits until both are released.
 *
 * @return 1 if both buttons were pressed in this sequence, 0 otherwise.
 */
uint8_t Button_BothPressed_FirstHour_SecondMinut_WaitRelease(void);

/**
 * @brief Checks if both buttons are currently released (logic LOW on both pins).
 *
 * This function returns 1 if both the Hour button (PC3) and the Minute button (PD2)
 * are not pressed at the moment — that is, both input pins are at logic LOW,
 * which is the idle state when using external pull-down resistors.
 *
 * @return 1 if both buttons are released, 0 otherwise.
 */
uint8_t Button_BothReleased(void);

/**
 * @brief Checks if both buttons are currently pressed (logic HIGH on both pins).
 *
 * This function returns 1 if both the Hour button (PC3) and the Minute button (PD2)
 * are pressed at the moment — that is, both input pins are at logic HIGH,
 * which is the idle state when using external pull-down resistors.
 *
 * @return 1 if both buttons are pressed, 0 otherwise.
 */
uint8_t Button_BothPressed(void);

// ============================================================================
// === Watchdog Safety Functions ==============================================
// ============================================================================

/**
 * @brief Ensure that EXTI for the Hour button is enabled,
 *        if the button is currently released (LOW).
 */
void Button_Hour_EnsureInterruptEnabled(void);

/**
 * @brief Ensure that EXTI for the Minute button is enabled,
 *        if the button is currently released (LOW).
 */
void Button_Minute_EnsureInterruptEnabled(void);

#endif // BUTTON_H
