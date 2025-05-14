#pragma once

#include <stdint.h>

/**
 * @brief Initializes the I2C peripheral.
 *
 * Sets up the I2C GPIO pins (PB4/PB5), clock frequency, TRISE value, and enables the peripheral.
 * Target frequency: 100 kHz, assuming 16 MHz system clock.
 */
void I2CInit(void);

/**
 * @brief Deinitializes the I2C peripheral.
 *
 * Resets all I2C control and configuration registers to their default values.
 */
void I2CDeinit(void);

/**
 * @brief Writes a buffer of data to a specific register of an I2C slave.
 *
 * @param slave 7-bit I2C slave address (left-aligned with R/W = 0)
 * @param addr Starting register address to write to
 * @param buffer Pointer to data buffer to send
 * @param size Number of bytes to write
 */
void I2CWrite(uint8_t slave, uint8_t addr, uint8_t *buffer, uint8_t size);

/**
 * @brief Reads a sequence of bytes from a specific register of an I2C slave.
 *
 * @param slave 7-bit I2C slave address (left-aligned with R/W = 0)
 * @param addr Starting register address to read from
 * @param buffer Pointer to data buffer to fill
 * @param size Number of bytes to read
 */
void I2CRead(uint8_t slave, uint8_t addr, uint8_t *buffer, uint8_t size);