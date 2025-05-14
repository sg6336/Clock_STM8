// =============================================================================
//     Includes
// =============================================================================
#include "button.h"
#include "input.h"
#include "delay.h"

// =============================================================================
//     Static Function Prototypes
// =============================================================================
static void _button_minute_wait_release(void);
static void _button_clear_minute_flag(void);
static void _button_enable_minute_interrupt(void);
static void _button_hour_wait_release(void);
static void _button_clear_hour_flag(void);
static void _button_enable_hour_interrupt(void);

// ============================================================================
//     Public API functions
// ============================================================================
void input_init() // Initialize buttons PC3 and PD2
{
    // Initialize buttons
    Buttons_Init(); // PC3 and PD2
}

uint8_t button_hour_is_pressed(void)
{
    button_debounce();
    return Button_HourPressed();
}

uint8_t button_minute_is_pressed(void)
{
    button_debounce();
    return Button_MinutePressed();
}

uint8_t button_both_is_pressed_first_hour_second_minute(void)
{
    return Button_BothPressed_FirstMinute_SecondHour_WaitRelease();
}

uint8_t button_both_is_pressed_first_minute_second_hour(void)
{
    return Button_BothPressed_FirstMinute_SecondHour_WaitRelease();
}

uint8_t button_both_is_released()
{
    return Button_BothReleased();
}

void button_minute_wait_release_and_clear_flag_and_debounce_and_enable_minute_interrupt()
{
    _button_minute_wait_release();
    // clear flag if still set
    _button_clear_minute_flag();
    button_debounce();
    _button_enable_minute_interrupt();
}

void button_hour_wait_release_and_clear_flag_and_debounce_and_enable_hour_interrupt()
{
    _button_hour_wait_release();
    // clear flag if still set
    _button_clear_hour_flag();
    button_debounce();
    _button_enable_hour_interrupt();
}

void button_debounce()
{
    delay_ms(100);
}

void button_enable_minute_interrupt()
{
    Button_Minute_EnableInterrupt();
}

void button_enable_hour_interrupt()
{
    Button_Hour_EnableInterrupt();
}

// ============================================================================
//     Static internal functions
// ============================================================================
/**
 * @brief Wait until the Minute button is released.
 */
static void _button_minute_wait_release()
{
    Button_Minute_WaitRelease();
}

/**
 * @brief Clear the minute button press flag.
 */
static void _button_clear_minute_flag()
{
    Button_MinutePressed(); // clear flag if still set
}

/**
 * @brief Enable EXTI interrupt for Minute button.
 */
static void _button_enable_minute_interrupt()
{
    Button_Minute_EnableInterrupt();
}

/**
 * @brief Wait until the Hour button is released.
 */
static void _button_hour_wait_release()
{
    Button_Hour_WaitRelease();
}

/**
 * @brief Clear the hour button press flag.
 */
static void _button_clear_hour_flag()
{
    Button_HourPressed(); // clear flag if still set
}

/**
 * @brief Enable EXTI interrupt for Hour button.
 */
static void _button_enable_hour_interrupt()
{
    Button_Hour_EnableInterrupt();
}
