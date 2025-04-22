/**
 * @file tm1637.c
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

#include "iostm8s103.h"
#include "tm1637.h"

#define CLK_PIN 5
#define DIO_PIN 6

#define CLOCK_DELAY 1

// Table which translates a digit into the segments
static const unsigned char cDigit2Seg[] = {0x3f, 0x6, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f};

static void delay_ms_tm1637(uint16_t milliseconds);
static void tm1637Start(void);
static void tm1637Stop(void);
static uint8_t tm1637GetAck(void);
static void tm1637WriteByte(uint8_t b);
static void tm1637Write(uint8_t *pData, uint8_t bLen);

// ============================================================================
// === Public API functions ===================================================
// ============================================================================

void tm1637Init(void)
{
	// CLK (PC5)
	PC_DDR |= (1 << CLK_PIN);  // output
	PC_CR1 |= (1 << CLK_PIN);  // push-pull
	PC_ODR &= ~(1 << CLK_PIN); // LOW

	// DIO (PC6)
	PC_DDR |= (1 << DIO_PIN);  // output
	PC_CR1 |= (1 << DIO_PIN);  // push-pull
	PC_ODR &= ~(1 << DIO_PIN); // LOW
}

void tm1637SetBrightness(uint8_t b)
{
	uint8_t bControl;
	if (b == 0)
		// display off
		bControl = 0x80;
	else
	{
		if (b > 8)
			b = 8;
		bControl = 0x88 | (b - 1);
	}
	tm1637Write(&bControl, 1);
}

void tm1637ShowDigits(char *pString)
{
	// commands and data to transmit
	unsigned char b, bTemp[16];
	unsigned char i, j;

	j = 0;
	// memory write command (auto increment mode)
	bTemp[0] = 0x40;
	tm1637Write(bTemp, 1);

	// set display address to first digit command
	bTemp[j++] = 0xc0;
	for (i = 0; i < 5; i++)
	{
		// position of the colon
		if (i == 2)
		{
			// turn on correct bit
			if (pString[i] == ':')
			{
				// second digit high bit controls colon LEDs
				bTemp[2] |= 0x80;
				// bTemp[2] = cDigit2Seg[pString[2] - '0'] | 0x80;
			}
		}
		else
		{
			b = 0;
			if (pString[i] >= '0' && pString[i] <= '9')
			{
				// segment data
				// b = cDigit2Seg[pString[i] & 0xf];
				b = cDigit2Seg[pString[i] - '0'];
			}
			else
			{
				b = 0;
			}
			bTemp[j++] = b;
		}
	}
	// send to the display
	tm1637Write(bTemp, j);
}

// ============================================================================
// === Static internal functions ==============================================
// ============================================================================

/**
 * @brief Sleep for the specified time (in ms).
 *
 * Implements a software blocking delay loop using nested NOPs.
 *
 * @param milliseconds Number of milliseconds to wait
 * @note This is not a precise timer and blocks CPU execution.
 */
static void delay_ms_tm1637(uint16_t milliseconds)
{
	volatile uint16_t i = 0;

	while (milliseconds--)
	{
		// for (i = 0; i < 1600; i++)
		{
			__asm("nop");
		}
	}
}

/**
 * @brief Starts a TM1637 data transmission.
 *
 * Sets CLK and DIO high, then pulls DIO low while CLK remains high.
 * Required before sending bytes.
 */
static void tm1637Start(void)
{
	PC_ODR |= (1 << DIO_PIN); // DIO high
	PC_ODR |= (1 << CLK_PIN); // CLK high
	delay_ms_tm1637(CLOCK_DELAY);
	PC_ODR &= ~(1 << DIO_PIN); // DIO low
}

/**
 * @brief Stops a TM1637 data transmission.
 *
 * Drives DIO and CLK low, then raises them back up in correct order.
 * Required after sending bytes.
 */
static void tm1637Stop(void)
{
	PC_ODR &= ~(1 << CLK_PIN); // CLK low
	delay_ms_tm1637(CLOCK_DELAY);
	PC_ODR &= ~(1 << DIO_PIN); // DIO low
	delay_ms_tm1637(CLOCK_DELAY);
	PC_ODR |= (1 << CLK_PIN); // CLK high
	delay_ms_tm1637(CLOCK_DELAY);
	PC_ODR |= (1 << DIO_PIN); // DIO high
}

/**
 * @brief Waits for the ACK signal from the TM1637.
 *
 * @note This implementation does not read actual line status.
 *       It only adds required delay and returns success.
 *
 * @return Always returns 1 (dummy ACK).
 */
static uint8_t tm1637GetAck(void)
{
	PC_ODR &= ~(1 << CLK_PIN);
	delay_ms_tm1637(CLOCK_DELAY);
	PC_ODR |= (1 << CLK_PIN);
	delay_ms_tm1637(CLOCK_DELAY);
	PC_ODR &= ~(1 << CLK_PIN);
	return 1;
}

/**
 * @brief Sends one byte to the TM1637, bit by bit.
 *
 * Each bit is sent LSB-first, toggling CLK and updating DIO accordingly.
 *
 * @param b Byte to send to the display
 */
static void tm1637WriteByte(uint8_t b)
{
	uint8_t i;

	for (i = 0; i < 8; i++)
	{
		PC_ODR &= ~(1 << CLK_PIN); // CLK low

		if (b & 1)
			PC_ODR |= (1 << DIO_PIN); // DIO high
		else
			PC_ODR &= ~(1 << DIO_PIN); // DIO low

		delay_ms_tm1637(CLOCK_DELAY);

		PC_ODR |= (1 << CLK_PIN); // CLK high
		delay_ms_tm1637(CLOCK_DELAY);

		b >>= 1;
	}
}

/**
 * @brief Writes a sequence of bytes to the TM1637 controller.
 *
 * @param pData Pointer to the byte array
 * @param bLen Number of bytes to write
 */
static void tm1637Write(uint8_t *pData, uint8_t bLen)
{
	uint8_t b, bAck;
	bAck = 1;
	tm1637Start();
	for (b = 0; b < bLen; b++)
	{
		tm1637WriteByte(pData[b]);
		bAck &= tm1637GetAck();
	}
	tm1637Stop();
}
