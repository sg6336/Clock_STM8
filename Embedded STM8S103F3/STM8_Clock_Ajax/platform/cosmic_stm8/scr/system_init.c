// =============================================================================
//     Includes
// =============================================================================
#include "iostm8s103.h"
#include "system_init.h"
#include "clock.h"
#include "display.h"
#include "logger.h"
#include "input.h"

// =============================================================================
//     Static Function Prototypes
// =============================================================================
static void CLK_init(void);

// ============================================================================
//     Public API functions
// ============================================================================
void init_hardware()
{
    CLK_init(); // Initialize system clock to 16 MHz using internal HSI oscillator

    clock_init();   // Initialize I2C (SDA: PB5, SCL: PB4) for DS3231
    display_init(); // Initialize TM1637 clock and data pins (PC5 and PC6)
    input_init();   // Initialize buttons PC3 and PD2
    logger_init();  // Initialize UART TX only, PD5, 9600 baud

    _asm("rim"); // â† Important! Enable global interrupts
}

// ============================================================================
//     Static internal functions
// ============================================================================
/**
 * @brief Initialize system clock to 16 MHz using internal HSI oscillator.
 */
static void CLK_init()
{
    CLK_SWR = 0xE1;      // select HSI as the clock source
    CLK_SWCR = (1 << 1); // enable switching (SWEN = 1)
    while (CLK_CMSR != 0xE1)
        ;              // wait until HSI becomes the active clock source
    CLK_CKDIVR = 0x00; // set HSI divider = 1, CPU divider = 1
    // CLK_PCKENR1 = 0xFF;    // enable clock for all peripherals connected to PCKENR1 bus (UART1, SPI, TIM1, TIM2, TIM3)
}