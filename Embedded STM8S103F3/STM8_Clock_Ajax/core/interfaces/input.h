#pragma once

#include <stdint.h>

/**
 * @brief Initialize button input pins and EXTI interrupts.
 */
void input_init(void); // Initialize buttons PC3 and PD2

/**
 * @brief Check if Hour button was pressed.
 * @return 1 if pressed, 0 otherwise.
 */
uint8_t button_hour_is_pressed(void);

/**
 * @brief Check if Minute button was pressed.
 * @return 1 if pressed, 0 otherwise.
 */
uint8_t button_minute_is_pressed(void);

/**
 * @brief Check if both buttons were pressed: first Hour, then Minute.
 * @return 1 if detected, 0 otherwise.
 */
uint8_t button_both_is_pressed_first_hour_second_minute(void);

/**
 * @brief Check if both buttons were pressed: first Minute, then Hour.
 * @return 1 if detected, 0 otherwise.
 */
uint8_t button_both_is_pressed_first_minute_second_hour(void);

/**
 * @brief Check if both buttons are currently released.
 * @return 1 if released, 0 otherwise.
 */
uint8_t button_both_is_released(void);

/**
 * @brief Finalizes processing of the Minute button press.
 *
 * Waits until the Minute button is released, clears the pending flag (if still set),
 * applies a software debounce delay, and re-enables the EXTI interrupt for the button.
 *
 * This function is typically called after handling a button-triggered event to reset
 * the button state and allow detection of the next press.
 *
 * @see button_minute_wait_release()
 * @see button_clear_minute_flag()
 * @see button_debounce()
 * @see button_enable_minute_interrupt()
 */
void button_minute_wait_release_and_clear_flag_and_debounce_and_enable_minute_interrupt(void);

/**
 * @brief Finalizes processing of the Hour button press.
 *
 * Waits until the Hour button is released, clears the pending flag (if still set),
 * applies a software debounce delay, and re-enables the EXTI interrupt for the button.
 *
 * This function is typically called after handling a button-triggered event to reset
 * the button state and allow detection of the next press.
 *
 * @see button_hour_wait_release()
 * @see button_clear_hour_flag()
 * @see button_debounce()
 * @see button_enable_hour_interrupt()
 */
void button_hour_wait_release_and_clear_flag_and_debounce_and_enable_hour_interrupt(void);

/**
 * @brief Enable EXTI interrupt for Minute button.
 */
void button_enable_minute_interrupt(void);

/**
 * @brief Enable EXTI interrupt for Hour button.
 */
void button_enable_hour_interrupt(void);
