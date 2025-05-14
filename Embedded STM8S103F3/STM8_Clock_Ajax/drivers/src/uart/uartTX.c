/**
 * @file uartTX.c
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

// =============================================================================
//     Includes
// =============================================================================
#include "iostm8s103.h"
#include "uartTX.h"

// =============================================================================
//     Defines
// =============================================================================
// UART1_SR Bit Masks
#define UART1_SR_TXE 0x80  // TX register empty
#define UART1_SR_TC 0x40   // Transmission complete
#define UART1_SR_RXNE 0x20 // Read data register not empty
#define UART1_SR_IDLE 0x10 // Idle line
#define UART1_SR_OR 0x08   // Overrun error
#define UART1_SR_NF 0x04   // Noise flag
#define UART1_SR_FE 0x02   // Framing error
#define UART1_SR_PE 0x01   // Parity error

// =============================================================================
//     Static Function Prototypes
// =============================================================================
static void _wait_uart_ready(void);

// ============================================================================
//     Public API functions
// ============================================================================
void uart_init(void)
{
    // --- Налаштування PD5 як TX ---
    // PD_DDR |= (1 << 5);    // PD5 як вихід
    // PD_CR1 |= (1 << 5);    // PD5 push-pull (для стабільного рівня)

    // --- Налаштування UART ---
    UART1_CR2 = 0x08;     // Увімкнути лише передавач (TX)
    UART1_CR3 &= ~(0x30); // Один стоп-біт

    // --- Встановлення швидкості 9600 бод при 16 МГц ---
    // UART_DIV = 16000000 / 9600 = 1666 = 0x0682
    // BRR1 = 0x68 (mantissa high byte)
    // BRR2 = 0x03 (fraction + mantissa low nibble)
    UART1_BRR2 = 0x03; // fraction = 0x03, mantissa[3:0] = 0x2 (STM8 формат)
    UART1_BRR1 = 0x68; // mantissa[11:4]
}

// #pragma noopt
void uart_send_char(char c)
{
    // while (!(UART1_SR & UART1_SR_TXE));  // Wait until ready
    _wait_uart_ready();
    UART1_DR = c;
    while (!(UART1_SR & UART1_SR_TC))
    {
        __asm("nop");
    }
}

// #pragma noopt
int uart_write(const char *str)
{
    uint8_t i = 0;
    while (str[i] != '\0')
    {
        // while (!(UART1_SR & UART1_SR_TXE));
        _wait_uart_ready();
        UART1_DR = str[i++];
        while (!(UART1_SR & UART1_SR_TC))
        {
            __asm("nop");
        }
    }
    return i;
}

// ============================================================================
//     Static internal functions
// ============================================================================
/**
 * @brief Waits until UART1 is ready to transmit a new byte.
 *
 * This function blocks execution until the TXE (Transmit Data Register Empty)
 * flag in UART1_SR is set, indicating that UART1 can accept a new byte for transmission.
 *
 * @note This is a blocking call. Use with care in time-critical loops.
 */
static void _wait_uart_ready(void)
{
    while (!(UART1_SR & UART1_SR_TXE))
        ;
}
