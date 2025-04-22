/**
 * @file uartTX.h
 * @brief Simple UART1 transmitter library for STM8 (Cosmic)
 * 
 * @author Denys Navrotskyi <navrotskyi@kai.edu.ua>
 * @date 2024–2025
 * @version 1.0
 * 
 * @details
 * This library provides a lightweight and low-level UART1 transmitter for STM8 microcontrollers. 
 * It is optimized for the Cosmic C compiler and works directly with hardware registers defined 
 * in iostm8s103.h, without relying on SPL or HAL.
 * 
 * Configuration:
 * - Target MCU: STM8S103F3
 * - Baud rate: 9600
 * - Clock: 16 MHz internal HSI
 * - TX only (no RX)
 * - TX pin: UART1_TX → PD5 (pin 20 on STM8S103F3P6)
 * 
 * Usage:
 * 1. Call uart_init() once at startup to configure UART1.
 * 2. Use uart_send_char() to send individual characters.
 * 3. Use uart_write() to send null-terminated strings.
 * 
 * Example:
 *     uart_init();
 *     uart_write("Hello STM8!\r\n");
 */

#ifndef UART_TX_H
#define UART_TX_H

#include <stdint.h>

/**
 * @brief Initializes UART1 for transmission at 9600 baud (16MHz).
 * 
 * @note TX only. RX is not configured.
 */
void uart_init(void);

/**
 * @brief Sends a single character over UART.
 * 
 * @param c Character to transmit
 * @see uart_write
 */
void uart_send_char(char c);

/**
 * @brief Sends a null-terminated string over UART.
 * 
 * @param str Pointer to string to transmit
 * @return Number of characters sent
 * @see uart_send_char
 */
int uart_write(const char *str);

#endif // UART_TX_H
