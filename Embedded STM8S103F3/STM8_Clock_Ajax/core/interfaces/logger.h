#pragma once

#include "config.h"

// #ifdef LOGGER_USE_UART
/**
 * @brief Initialize UART hardware for logger.
 *
 * Sets up UART TX on PD5, 9600 baud rate.
 */
void logger_init(void); // Initialize UART TX only, PD5, 9600 baud

/**
 * @brief Send a string message via UART.
 *
 * @param msg Null-terminated string to send.
 */
void logger_write(const char *msg);