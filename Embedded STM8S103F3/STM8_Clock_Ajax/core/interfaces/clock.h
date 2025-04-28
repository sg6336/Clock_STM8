#pragma once

#include <stdint.h>

/**
 * @brief Struct representing clock time.
 */
typedef struct
{
    uint8_t hours;
    uint8_t minutes;
    uint8_t seconds;
} ClockTime;

/**
 * @brief Global time structure reflecting the current time.
 */
extern volatile ClockTime current_time;

/**
 * @brief Initialize I2C communication with DS3231 RTC module.
 */
void clock_init(void); // Initialize I2C (SDA: PB5, SCL: PB4) for DS3231

/**
 * @brief Read current time from DS3231 RTC.
 */
void get_time_from_clock(void);

/**
 * @brief Set current time to DS3231 RTC.
 */
void set_time_to_clock(void);

/**
 * @brief Increment the current time by one minute.
 */
void add_one_minute(void);

/**
 * @brief Increment the current time by one hour.
 */
void add_one_hour(void);
