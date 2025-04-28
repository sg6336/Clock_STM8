/**
 * @file tm1637.h
 * @brief TM1637 4-digit 7-segment display driver for STM8 (bare-metal)
 *
 * @author Denys Navrotskyi <navrotskyi@kai.edu.ua>
 * @date 2024-2025
 * @version 1.0
 *
 * @details
 * This library provides a minimal implementation for TM1637 display communication
 * using GPIO pins (PC5 as CLK, PC6 as DIO). It is optimized for Cosmic compiler
 * and STM8S103 microcontrollers.
 */

#ifndef TM1637_H
#define TM1637_H

#include <stdint.h>

/**
 * @brief Initialize TM1637 display (uses PC5 as CLK, PC6 as DIO)
 */
void tm1637Init(void);

/**
 * @brief Set display brightness
 * @param level Brightness level: 0 (off) to 8 (max)
 */
void tm1637SetBrightness(uint8_t level);

/**
 * @brief Show 4-digit string (e.g. "12:34", "45 67")
 * @param pString Pointer to 5-character string, where colon (:) at position 2 controls colon segment
 */
void tm1637ShowDigits(char *pString);

#endif // TM1637_H
