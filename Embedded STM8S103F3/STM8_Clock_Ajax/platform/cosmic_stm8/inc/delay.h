#pragma once

#include <stdint.h>

/**
 * @brief Delay function with software loop.
 *
 * Delays execution for an approximate number of milliseconds.
 *
 * @param ms Number of milliseconds to delay.
 *
 * @note Blocking delay. Not cycle-accurate. Depends on CPU clock stability.
 * @note Timing may drift if core frequency is changed.
 *
 * @bug Timing is approximate; for accurate delays, use a hardware timer.
 * @todo Replace with timer-based non-blocking delays for better accuracy.
 *
 * @see system_init.h — for system clock initialization at 16 MHz.
 */
void delay_ms(uint16_t ms);