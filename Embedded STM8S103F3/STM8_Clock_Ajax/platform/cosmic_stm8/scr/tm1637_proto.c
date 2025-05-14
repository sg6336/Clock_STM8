// =============================================================================
//     Includes
// =============================================================================
#include "iostm8s103.h"
#include "tm1637_proto.h"

// =============================================================================
//     Defines
// =============================================================================
#define CLK_PIN 5
#define DIO_PIN 6

#define CLOCK_DELAY 1

// =============================================================================
//     Static Function Prototypes
// =============================================================================
static void _delay_ms_tm1637(uint16_t milliseconds);
static uint8_t _tm1637GetAck(void);
static void _tm1637WriteByte(uint8_t b);

// ============================================================================
//     Public API functions
// ============================================================================
void tm1637_init(void)
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

void tm1637_start(void)
{
    PC_ODR |= (1 << DIO_PIN); // DIO high
    PC_ODR |= (1 << CLK_PIN); // CLK high
    _delay_ms_tm1637(CLOCK_DELAY);
    PC_ODR &= ~(1 << DIO_PIN); // DIO low
}

void tm1637_stop(void)
{
    PC_ODR &= ~(1 << CLK_PIN); // CLK low
    _delay_ms_tm1637(CLOCK_DELAY);
    PC_ODR &= ~(1 << DIO_PIN); // DIO low
    _delay_ms_tm1637(CLOCK_DELAY);
    PC_ODR |= (1 << CLK_PIN); // CLK high
    _delay_ms_tm1637(CLOCK_DELAY);
    PC_ODR |= (1 << DIO_PIN); // DIO high
}

void tm1637_write(uint8_t *pData, uint8_t bLen)
{
    uint8_t b, bAck;
    bAck = 1;
    tm1637_start();
    for (b = 0; b < bLen; b++)
    {
        _tm1637WriteByte(pData[b]);
        bAck &= _tm1637GetAck();
    }
    tm1637_stop();
}

// ============================================================================
//     Static internal functions
// ============================================================================
/**
 * @brief Sleep for the specified time (in ms).
 *
 * Implements a software blocking delay loop using nested NOPs.
 *
 * @param milliseconds Number of milliseconds to wait
 * @note This is not a precise timer and blocks CPU execution.
 */
static void _delay_ms_tm1637(uint16_t milliseconds)
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
 * @brief Waits for the ACK signal from the TM1637.
 *
 * @note This implementation does not read actual line status.
 *       It only adds required delay and returns success.
 *
 * @return Always returns 1 (dummy ACK).
 */
static uint8_t _tm1637GetAck(void)
{
    PC_ODR &= ~(1 << CLK_PIN);
    _delay_ms_tm1637(CLOCK_DELAY);
    PC_ODR |= (1 << CLK_PIN);
    _delay_ms_tm1637(CLOCK_DELAY);
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
static void _tm1637WriteByte(uint8_t b)
{
    uint8_t i;

    for (i = 0; i < 8; i++)
    {
        PC_ODR &= ~(1 << CLK_PIN); // CLK low

        if (b & 1)
            PC_ODR |= (1 << DIO_PIN); // DIO high
        else
            PC_ODR &= ~(1 << DIO_PIN); // DIO low

        _delay_ms_tm1637(CLOCK_DELAY);

        PC_ODR |= (1 << CLK_PIN); // CLK high
        _delay_ms_tm1637(CLOCK_DELAY);

        b >>= 1;
    }
}
