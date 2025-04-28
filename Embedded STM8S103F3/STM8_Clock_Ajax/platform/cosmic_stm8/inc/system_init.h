#pragma once

/**
 * @brief Initialize all hardware peripherals.
 *
 * Sets up the system clock (16 MHz HSI), I2C bus for DS3231 RTC,
 * TM1637 7-segment display, button input pins, and UART logger.
 * Enables global interrupts after configuration.
 *
 * @return None.
 *
 * @note Must be called before any peripherals are accessed in the main program.
 *
 * @see clock.h, display.h, input.h, logger.h
 */
void init_hardware(void);