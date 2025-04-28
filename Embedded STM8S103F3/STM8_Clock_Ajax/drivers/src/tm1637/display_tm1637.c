// =============================================================================
//     Includes
// =============================================================================
#include "display.h"
#include "tm1637.h"

// ============================================================================
//     Public API functions
// ============================================================================
void display_init(void) // Initialize TM1637 clock and data pins (PC5 and PC6)
{
    // Initialize TM1637 clock and data pins (PC5 and PC6)
    tm1637Init(); // PC5 (CLK), PC6 (DIO)
    tm1637SetBrightness(1);
}

void update_display_time(uint8_t hours, uint8_t min, uint8_t secs)
{
    static uint8_t displayBuffer[8];

    if (secs & 1)
    {
        displayBuffer[0] = '0' + hours / 10;
        displayBuffer[1] = '0' + hours % 10;
        displayBuffer[2] = ':';
        displayBuffer[3] = '0' + min / 10;
        displayBuffer[4] = '0' + min % 10;
        displayBuffer[5] = '\0';
    }
    else
    {
        displayBuffer[0] = '0' + hours / 10;
        displayBuffer[1] = '0' + hours % 10;
        displayBuffer[2] = ' ';
        displayBuffer[3] = '0' + min / 10;
        displayBuffer[4] = '0' + min % 10;
        displayBuffer[5] = '\0';
    }
    tm1637ShowDigits(displayBuffer);
}

void set_brightness_display_high(void)
{
    tm1637SetBrightness(8);
}

void set_brightness_display_low(void)
{
    tm1637SetBrightness(1);
}

void display_show_wait_indicator()
{
    static const uint8_t displayWaitIndicator[8] = {' ', ' ', ':', ' ', ' ', '\0'};
    tm1637ShowDigits(displayWaitIndicator);
}