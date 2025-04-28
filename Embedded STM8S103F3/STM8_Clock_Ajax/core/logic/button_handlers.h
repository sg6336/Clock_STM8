#pragma once

#include <stdint.h>

/**
 * @brief Handle the event when the Hour button is pressed.
 *
 * Increments hours or toggles time setting mode based on button sequences.
 *
 * @return None.
 */
void handle_hour_button(void);

/**
 * @brief Handle the event when the Minute button is pressed.
 *
 * Increments minutes or toggles time setting mode based on button sequences.
 *
 * @return None.
 */
void handle_minute_button(void);

/**
 * @brief Handle logic when both buttons are released.
 *
 * Syncs time from RTC if not in time setting mode and updates the display.
 *
 * @return None.
 */
void handle_both_buttons(void);