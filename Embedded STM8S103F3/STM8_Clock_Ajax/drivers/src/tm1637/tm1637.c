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

// =============================================================================
//     Includes
// =============================================================================
#include "iostm8s103.h"
#include "tm1637_proto.h"
#include "tm1637.h"

// =============================================================================
//     Static Variables
// =============================================================================
// Table which translates a digit into the segments
static const unsigned char cDigit2Seg[] = {0x3f, 0x6, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f};

// ============================================================================
//     Public API functions
// ============================================================================
void tm1637Init(void)
{
	tm1637_init();
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
	tm1637_write(&bControl, 1);
}

void tm1637ShowDigits(char *pString)
{
	// commands and data to transmit
	unsigned char b, bTemp[16];
	unsigned char i, j;

	j = 0;
	// memory write command (auto increment mode)
	bTemp[0] = 0x40;
	tm1637_write(bTemp, 1);

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
	tm1637_write(bTemp, j);
}
