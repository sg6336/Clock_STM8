/**
 * @file ds3231Time.c
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

// =============================================================================
//     Includes
// =============================================================================
#include "iostm8s103.h"
#include "I2C.h"
#include "ds3231Time.h"

// =============================================================================
//     Defines
// =============================================================================
// ==== DS3231 I2C Address ====
#define DS3231_ADDR 0xD0 // slave address 1101 0000

// ==== DS3231 Register Map (used for RTC only) ====
#define DS3231_SECONDS 0x00
#define DS3231_MINUTES 0x01
#define DS3231_HOURS 0x02
#define DS3231_DAY 0x03
#define DS3231_DATE 0x04
#define DS3231_MONTH 0x05
#define DS3231_YEAR 0x06
#define DS3231_A1_SECONDS 0x07
#define DS3231_A1_MINUTES 0x08
#define DS3231_A1_HOURS 0x09
#define DS3231_A1_DAY_DATE 0x0A
#define DS3231_A2_MINUTES 0x0B
#define DS3231_A2_HOURS 0x0C
#define DS3231_A2_DAY_DATE 0x0D
#define DS3231_CONTROL 0x0E
#define DS3231_CTRL_STATUS 0x0F
#define DS3231_AGING_OFFSET 0x10
#define DS3231_TEMP_MSB 0x11
#define DS3231_TEMP_LSB 0x12

// ============================================================================
//     Public API functions
// ============================================================================
void DS3231_GetTime(uint8_t *buf, uint8_t size)
{
  I2CRead(DS3231_ADDR, DS3231_SECONDS, buf, size);
}

void DS3231_SetTime(uint8_t *buf, uint8_t size)
{
// #define SETTIME
#ifdef SETTIME
  buf[0] = (__TIME__[6] - '0') * 16 + (__TIME__[7] - '0');
  buf[1] = (__TIME__[3] - '0') * 16 + (__TIME__[4] - '0');
  buf[2] = (__TIME__[0] - '0') * 16 + (__TIME__[1] - '0');
  I2CWrite(DS3231_ADDR, DS3231_SECONDS, buf, size);
#else
  (void *)buf;
  (void *)size;
#endif
}

void DS3231_SetTimeManual(uint8_t hours_bcd, uint8_t minutes_bcd, uint8_t seconds_bcd)
{
  uint8_t buf[3] = {seconds_bcd, minutes_bcd, hours_bcd};
  I2CWrite(DS3231_ADDR, DS3231_SECONDS, buf, 3);
}
