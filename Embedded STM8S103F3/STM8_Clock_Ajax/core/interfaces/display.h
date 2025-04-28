#pragma once

#include <stdint.h>

/**
 * @brief Initialize TM1637 display hardware (PC5 and PC6 pins).
 */
void display_init(void); // Initialize TM1637 clock and data pins (PC5 and PC6)

/**
 * @brief Update the TM1637 display with the given time.
 *
 * Displays hours, minutes, and seconds with a blinking colon every second.
 *
 * @param hours Current hour to display [0–23].
 * @param min Current minute to display [0–59].
 * @param secs Current second to display [0–59].
 */
void update_display_time(uint8_t hours, uint8_t min, uint8_t secs);

/**
 * @brief Set TM1637 display brightness to maximum.
 */
void set_brightness_display_high(void); // tm1637SetBrightness(8);

/**
 * @brief Set TM1637 display brightness to minimum.
 */
void set_brightness_display_low(void); // tm1637SetBrightness(1);

/**
 * @brief Display a wait indicator pattern on TM1637 display.
 */
void display_show_wait_indicator(void); // tm1637ShowDigits(displayWaitIndicator);