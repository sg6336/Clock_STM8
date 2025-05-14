#pragma once

#include <stdint.h>

/**
 * @brief Initialize TM1637 display (uses PC5 as CLK, PC6 as DIO)
 */
void tm1637_init(void);

/**
 * @brief Starts a TM1637 data transmission.
 *
 * Sets CLK and DIO high, then pulls DIO low while CLK remains high.
 * Required before sending bytes.
 */
void tm1637_start(void);

/**
 * @brief Stops a TM1637 data transmission.
 *
 * Drives DIO and CLK low, then raises them back up in correct order.
 * Required after sending bytes.
 */
void tm1637_stop(void);

/**
 * @brief Writes a sequence of bytes to the TM1637 controller.
 *
 * @param pData Pointer to the byte array
 * @param bLen Number of bytes to write
 */
void tm1637_write(uint8_t *pData, uint8_t bLen);