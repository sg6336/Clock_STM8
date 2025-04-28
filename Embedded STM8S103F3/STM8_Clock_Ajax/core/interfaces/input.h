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
 * @brief Wait until the Minute button is released.
 */
void button_minute_wait_release(void);

/**
 * @brief Clear the minute button press flag.
 */
void button_clear_minute_flag(void); // TODO: запихнути в button_minute_wait_release();

/**
 * @brief Enable EXTI interrupt for Minute button.
 */
void button_enable_minute_interrupt(void); // TODO: запихнути в button_minute_wait_release();

/**
 * @brief Wait until the Hour button is released.
 */
void button_hour_wait_release(void);

/**
 * @brief Clear the hour button press flag.
 */
void button_clear_hour_flag(void); // TODO: запихнути в button_hour_wait_release();

/**
 * @brief Enable EXTI interrupt for Hour button.
 */
void button_enable_hour_interrupt(void); // TODO: запихнути в button_hour_wait_release();

/**
 * @brief Simple software debounce delay for buttons.
 */
void button_debounce(void); // TODO: запихнути в button_hour_wait_release(); та button_minute_wait_release();