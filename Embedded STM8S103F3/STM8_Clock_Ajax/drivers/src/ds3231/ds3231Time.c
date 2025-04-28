/**
 * @file ds3231Time.c
 * @brief DS3231 RTC I2C library for STM8S103 (bare-metal, no SPL)
 *
 * @author Denys Navrotskyi <navrotskyi@kai.edu.ua>
 * @date 2024-2025
 * @version 1.0
 *
 * @details
 * This library communicates with the DS3231 real-time clock over I2C,
 * implemented using direct register access (no SPL).
 *
 * I2C is configured on STM8S103F3 as follows:
 * - SDA: PB5
 * - SCL: PB4
 * - GPIO is initialized in open-drain, slow mode
 * - Clock speed: 100 kHz (based on 16 MHz internal HSI)
 *
 * Compatible with Cosmic C compiler and iostm8s103.h register definitions.
 */

// =============================================================================
//     Includes
// =============================================================================
#include "iostm8s103.h"
#include "ds3231Time.h"

// =============================================================================
//     Defines
// =============================================================================
// ==== I2C Pin Configuration ====
// #define I2C_PORT (GPIOB)
#define I2C_SDA (1 << 5)
#define I2C_SCL (1 << 4)

// ==== DS3231 I2C Address ====
#define DS3231_ADDR 0xD0 // slave address 1101 0000

// ==== DS3231 Register Map (used for RTC only) ====
#define DS3231_SECONDS 0x00
#define DS3231_MINUTES 0x01
#define DS3231_HOURS 0x02
#define DS3231_DAY 0x03
#define DS3231_DATE 0x04
#define DS3231_MONTH 0x05
#define DS3231_YEAR 0x06
#define DS3231_A1_SECONDS 0x07
#define DS3231_A1_MINUTES 0x08
#define DS3231_A1_HOURS 0x09
#define DS3231_A1_DAY_DATE 0x0A
#define DS3231_A2_MINUTES 0x0B
#define DS3231_A2_HOURS 0x0C
#define DS3231_A2_DAY_DATE 0x0D
#define DS3231_CONTROL 0x0E
#define DS3231_CTRL_STATUS 0x0F
#define DS3231_AGING_OFFSET 0x10
#define DS3231_TEMP_MSB 0x11
#define DS3231_TEMP_LSB 0x12

// ==== I2C Bit Masks ====

#define I2C_DIRECTION_TX 0x00
#define I2C_DIRECTION_RX 0x01

#define I2C_CR1_PE ((uint8_t)0x01)    // Peripheral Enable
#define I2C_CR2_ACK ((uint8_t)0x04)   // Acknowledge Enable
#define I2C_CR2_START ((uint8_t)0x01) // Start Generation
#define I2C_CR2_STOP ((uint8_t)0x02)  // Stop Generation

#define I2C_SR1_SB ((uint8_t)0x01)   // Start Bit (Master mode)
#define I2C_SR1_ADDR ((uint8_t)0x02) // Address sent/matched
#define I2C_SR1_BTF ((uint8_t)0x04)  // Byte Transfer Finished
#define I2C_SR1_TXE ((uint8_t)0x80)  // Data Register Empty
#define I2C_SR1_RXNE ((uint8_t)0x40) // Data Register Not Empty

#define I2C_SR3_MSL ((uint8_t)0x01) // Master/Slave

#define I2C_CR1_RESET_VALUE ((uint8_t)0x00)
#define I2C_CR2_RESET_VALUE ((uint8_t)0x00)
#define I2C_FREQR_RESET_VALUE ((uint8_t)0x00)
#define I2C_OARL_RESET_VALUE ((uint8_t)0x00)
#define I2C_OARH_RESET_VALUE ((uint8_t)0x00)
#define I2C_ITR_RESET_VALUE ((uint8_t)0x00)
#define I2C_CCRL_RESET_VALUE ((uint8_t)0x00)
#define I2C_CCRH_RESET_VALUE ((uint8_t)0x00)
#define I2C_TRISER_RESET_VALUE ((uint8_t)0x02)

#define ENABLE 1  /*!< Transmission direction */
#define DISABLE 0 /*!< Reception direction */

// =============================================================================
//     Static Function Prototypes
// =============================================================================
static void gpio_init(void);
static void I2CWrite(uint8_t slave, uint8_t addr, uint8_t *buffer, uint8_t size);
static void I2CRead(uint8_t slave, uint8_t addr, uint8_t *buffer, uint8_t size);
static void I2C_Cmd(uint8_t NewState);
static void I2C_Send7bitAddress(uint8_t Address, uint8_t Direction);
static void I2C_GenerateSTART(uint8_t NewState);
static void I2C_SendData(uint8_t Data);
static void I2C_GenerateSTOP(uint8_t NewState);
static uint8_t I2C_ReceiveData(void);

// ============================================================================
//     Public API functions
// ============================================================================
void DS3231_GetTime(uint8_t *buf, uint8_t size)
{
  I2CRead(DS3231_ADDR, DS3231_SECONDS, buf, size);
}

void DS3231_SetTime(uint8_t *buf, uint8_t size)
{
// #define SETTIME
#ifdef SETTIME
  buf[0] = (__TIME__[6] - '0') * 16 + (__TIME__[7] - '0');
  buf[1] = (__TIME__[3] - '0') * 16 + (__TIME__[4] - '0');
  buf[2] = (__TIME__[0] - '0') * 16 + (__TIME__[1] - '0');
  I2CWrite(DS3231_ADDR, DS3231_SECONDS, buf, size);
#else
  (void *)buf;
  (void *)size;
#endif
}

void DS3231_SetTimeManual(uint8_t hours_bcd, uint8_t minutes_bcd, uint8_t seconds_bcd)
{
  uint8_t buf[3] = {seconds_bcd, minutes_bcd, hours_bcd};
  I2CWrite(DS3231_ADDR, DS3231_SECONDS, buf, 3);
}

void I2CInit()
{
  gpio_init(); // Configure GPIO pins for I2C (PB4, PB5)

  I2C_CR1 = 0x00;        // Disable I2C peripheral before configuration
  I2C_FREQR = 16;        // Set peripheral clock frequency in MHz (16 MHz)
  I2C_CCRL = 80;         // Configure clock control: 100 kHz = 16 MHz / (2 * 100 kHz)
  I2C_TRISER = 17;       // Configure TRISE: freq + 1 = 17 for standard mode
  I2C_CR2 = I2C_CR2_ACK; // Enable ACK generation
  I2C_CR1 |= I2C_CR1_PE; // Enable the I2C peripheral
}

void I2CDeinit()
{
  I2C_CR1 = I2C_CR1_RESET_VALUE;       // Reset control register 1
  I2C_CR2 = I2C_CR2_RESET_VALUE;       // Reset control register 2
  I2C_FREQR = I2C_FREQR_RESET_VALUE;   // Reset frequency register
  I2C_OARL = I2C_OARL_RESET_VALUE;     // Reset own address register low
  I2C_OARH = I2C_OARH_RESET_VALUE;     // Reset own address register high
  I2C_ITR = I2C_ITR_RESET_VALUE;       // Reset interrupt register
  I2C_CCRL = I2C_CCRL_RESET_VALUE;     // Reset clock control register low
  I2C_CCRH = I2C_CCRH_RESET_VALUE;     // Reset clock control register high
  I2C_TRISER = I2C_TRISER_RESET_VALUE; // Reset TRISE register
}

// ============================================================================
//     Static internal functions
// ============================================================================
/**
 * @brief Initializes GPIOB (PB4, PB5) for I2C communication.
 *        Sets them as open-drain outputs with slow mode.
 */
static void gpio_init()
{
  PB_ODR |= (I2C_SCL | I2C_SDA);  // Set HIGH on both lines
  PB_DDR |= (I2C_SCL | I2C_SDA);  // Configure as output
  PB_CR1 &= ~(I2C_SCL | I2C_SDA); // Open-drain
  PB_CR2 &= ~(I2C_SCL | I2C_SDA); // Slow-mode (low speed)

#if 0
    for (uint8_t i = 0; i < 10; i++)
    {
        // toggle clock to reset any strange slave state //
        GPIO_WriteReverse(I2C_PORT, I2C_SCL);
        // delay around 5 us //
        for(volatile uint8_t j = 0; j < 10; j++);
    }
#endif
}

/**
 * @brief Writes a buffer of data to a specific register of an I2C slave.
 *
 * @param slave 7-bit I2C slave address (left-aligned with R/W = 0)
 * @param addr Starting register address to write to
 * @param buffer Pointer to data buffer to send
 * @param size Number of bytes to write
 */
static void I2CWrite(uint8_t slave, uint8_t addr, uint8_t *buffer, uint8_t size)
{
  // need to read regs to clear some flags
  volatile uint8_t reg;
  uint8_t index = 0;

  I2C_Cmd(ENABLE);
  I2C_GenerateSTART(ENABLE);
  // wait until start is sent
  while (!(I2C_SR1 & I2C_SR1_SB))
    ;
  // EV5: SB=1, cleared by reading SR1 register followed by writing DR register with Address.

  I2C_Send7bitAddress(slave, I2C_DIRECTION_TX);
  // wait addr bit, if set - we have ACK
  while (!(I2C_SR1 & I2C_SR1_ADDR))
    ;
  // EV6: ADDR=1, cleared by reading SR1 register followed by reading SR3
  reg = I2C_SR1;
  reg = I2C_SR3;
  // EV8_1: TXE=1, shift register empty, data register empty, write DR register.

  I2C_SendData(addr);
  while (!(I2C_SR1 & I2C_SR1_TXE))
    ;

  while (size)
  {
    size--;
    I2C_SendData(buffer[index]);
    index++;
    // wait TXE, set after data moved to shift reg
    while (!(I2C_SR1 & I2C_SR1_TXE))
      ;
    // EV8: TXE=1, shift register not empty, data register empty, cleared by writing DR register
  }
  // wait bte
  while (!(I2C_SR1 & I2C_SR1_BTF))
    ;
  // EV8_2: TXE=1, BTF = 1, Program STOP request. TXE and BTF are cleared by HW by stop condition

  // stop after this byte
  I2C_GenerateSTOP(ENABLE);

  // wait MSL
  while ((I2C_SR3 & I2C_SR3_MSL))
    ;
  I2C_Cmd(DISABLE);
}

/**
 * @brief Reads a sequence of bytes from a specific register of an I2C slave.
 *
 * @param slave 7-bit I2C slave address (left-aligned with R/W = 0)
 * @param addr Starting register address to read from
 * @param buffer Pointer to data buffer to fill
 * @param size Number of bytes to read
 */
static void I2CRead(uint8_t slave, uint8_t addr, uint8_t *buffer, uint8_t size)
{
  // need to read regs to clear some flags
  volatile uint8_t reg;
  uint8_t index = 0;

  I2C_Cmd(ENABLE);
  I2C_GenerateSTART(ENABLE);
  // wait until start is sent
  // printf("I2CRead: wait tx SB\r\n");
  while (!(I2C_SR1 & I2C_SR1_SB))
    ;
  // EV5: SB=1, cleared by reading SR1 register followed by writing DR register with Address.

  I2C_Send7bitAddress(slave, I2C_DIRECTION_TX);
  // wait addr bit, if set - we have ACK
  // printf("I2CRead: wait tx ADDR\r\n");
  while (!(I2C_SR1 & I2C_SR1_ADDR))
    ;
  // EV6: ADDR=1, cleared by reading SR1 register followed by reading SR3
  reg = I2C_SR1;
  reg = I2C_SR3;
  // EV8_1: TXE=1, shift register empty, data register empty, write DR register.

  I2C_SendData(addr);
  // printf("I2CRead: wait tx addr TXE\r\n");
  while (!(I2C_SR1 & I2C_SR1_TXE))
    ;
  // printf("I2CRead: wait tx addr BTF\r\n");
  while (!(I2C_SR1 & I2C_SR1_BTF))
    ;

  // we should ACK received data
  I2C_CR2 |= I2C_CR2_ACK;

  I2C_GenerateSTART(ENABLE);
  // printf("I2CRead: wait rx SB\r\n");
  while (!(I2C_SR1 & I2C_SR1_SB))
    ;

  I2C_Send7bitAddress(slave, I2C_DIRECTION_RX);
  // wait addr bit, if set - we have ACK
  // printf("I2CRead: wait rx ADDR\r\n");
  while (!(I2C_SR1 & I2C_SR1_ADDR))
    ;
  // EV6: ADDR=1, cleared by reading SR1 register followed by reading SR3
  reg = I2C_SR1;
  reg = I2C_SR3;

  while (size)
  {
    size--;
    if (size == 0)
    {
      // we should NACK last byte
      I2C_CR2 &= ~I2C_CR2_ACK;
    }
    // printf("I2CRead: wait rx RXNE\r\n");
    while (!(I2C_SR1 & I2C_SR1_RXNE))
      ;
    buffer[index] = I2C_ReceiveData();
    index++;
  }

  // stop after this byte
  I2C_GenerateSTOP(ENABLE);

  // wait MSL
  // printf("I2CRead: wait MSL\r\n");
  while ((I2C_SR3 & I2C_SR3_MSL))
    ;
  I2C_Cmd(DISABLE);
}

/**
 * @brief Enables or disables the I2C peripheral.
 *
 * @param NewState ENABLE or DISABLE
 */
static void I2C_Cmd(uint8_t NewState)
{
  if (NewState != DISABLE)
  {
    /* Enable I2C peripheral */
    I2C_CR1 |= I2C_CR1_PE;
  }
  else /* NewState == DISABLE */
  {
    /* Disable I2C peripheral */
    I2C_CR1 &= (uint8_t)(~I2C_CR1_PE);
  }
}

/**
 * @brief Generates a START condition on the I2C bus.
 *
 * @param NewState ENABLE to generate, DISABLE to cancel
 */
static void I2C_GenerateSTART(uint8_t NewState)
{
  if (NewState != DISABLE)
  {
    /* Generate a START condition */
    I2C_CR2 |= I2C_CR2_START;
  }
  else /* NewState == DISABLE */
  {
    /* Disable the START condition generation */
    I2C_CR2 &= (uint8_t)(~I2C_CR2_START);
  }
}

/**
 * @brief Generates a STOP condition on the I2C bus.
 *
 * @param NewState ENABLE to generate, DISABLE to cancel
 */
static void I2C_GenerateSTOP(uint8_t NewState)
{
  if (NewState != DISABLE)
  {
    /* Generate a STOP condition */
    I2C_CR2 |= I2C_CR2_STOP;
  }
  else /* NewState == DISABLE */
  {
    /* Disable the STOP condition generation */
    I2C_CR2 &= (uint8_t)(~I2C_CR2_STOP);
  }
}

/**
 * @brief Sends the slave address with direction bit to the I2C bus.
 *
 * @param Address 7-bit I2C address (left-aligned)
 * @param Direction I2C_DIRECTION_TX or I2C_DIRECTION_RX
 */
static void I2C_Send7bitAddress(uint8_t Address, uint8_t Direction)
{
  /* Clear bit0 (direction) just in case */
  Address &= (uint8_t)0xFE;

  /* Send the Address + Direction */
  I2C_DR = (uint8_t)(Address | (uint8_t)Direction);
}

/**
 * @brief Sends a single byte to the I2C bus.
 *
 * @param Data Byte to transmit
 */
static void I2C_SendData(uint8_t Data)
{
  /* Write in the DR register the data to be sent */
  I2C_DR = Data;
}

/**
 * @brief Reads the latest received byte from the I2C data register.
 *
 * @return uint8_t Received byte
 */
static uint8_t I2C_ReceiveData(void)
{
  /* Return the data present in the DR register */
  return ((uint8_t)I2C_DR);
}