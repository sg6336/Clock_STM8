/**
 * @file ds3231Time.h
 * @brief DS3231 RTC I2C library for STM8S103 (bare-metal, no SPL)
 *
 * @author Denys Navrotskyi <navrotskyi@kai.edu.ua>
 * @date 2024-2025
 * @version 1.0
 *
 * @details
 * This library communicates with the DS3231 real-time clock over I2C,
 * implemented using direct register access (no SPL).
 *
 * I2C is configured on STM8S103F3 as follows:
 * - SDA: PB5
 * - SCL: PB4
 * - GPIO is initialized in open-drain, slow mode
 * - Clock speed: 100 kHz (based on 16 MHz internal HSI)
 *
 * Compatible with Cosmic C compiler and iostm8s103.h register definitions.
 */

#ifndef DS3231_H
#define DS3231_H

#include <stdint.h>

/**
 * @brief Reads the current time from the DS3231.
 *
 * This function initiates an I2C read transaction starting from the seconds register (0x00)
 * and stores the resulting time data in the provided buffer.
 *
 * @param buf Pointer to a buffer to store the result (typically 7 bytes: sec, min, hr, day, date, month, year)
 * @param size Number of bytes to read (should not exceed 7)
 */
void DS3231_GetTime(uint8_t *buf, uint8_t size);

/**
 * @brief Writes the time to the DS3231.
 *
 * This function sends the specified buffer to the DS3231 starting from the seconds register (0x00).
 * The time should be in BCD format.
 *
 * @param buf Pointer to a buffer containing the time values to set
 * @param size Number of bytes to write (typically 3–7)
 */
void DS3231_SetTime(uint8_t *buf, uint8_t size);

/**
 * @brief Manually sets the time on the DS3231.
 *
 * @param hours_bcd Hours in BCD format
 * @param minutes_bcd Minutes in BCD format
 * @param seconds_bcd Seconds in BCD format
 */
void DS3231_SetTimeManual(uint8_t hours_bcd, uint8_t minutes_bcd, uint8_t seconds_bcd);

#endif // DS3231_H