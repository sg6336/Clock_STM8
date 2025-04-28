// =============================================================================
//     Includes
// =============================================================================
#include "button.h"
#include "input.h"
#include "delay.h"

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
    return Button_HourPressed();
}

uint8_t button_minute_is_pressed(void)
{
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

void button_minute_wait_release()
{
    Button_Minute_WaitRelease();
}

void button_clear_minute_flag() // TODO: запихнути в button_minute_wait_release();
{
    Button_MinutePressed(); // clear flag if still set
}

void button_enable_minute_interrupt() // TODO: запихнути в button_minute_wait_release();
{
    Button_Minute_EnableInterrupt();
}

// void button_debounce(void) // TODO: запихнути в button_hour_wait_release(); та button_minute_wait_release();
// {
//     delay_ms(100); // debounce
// }

void button_hour_wait_release()
{
    Button_Hour_WaitRelease();
}

void button_clear_hour_flag(void) // TODO: запихнути в button_hour_wait_release();
{
    Button_HourPressed(); // clear flag if still set
}

void button_enable_hour_interrupt(void) // TODO: запихнути в button_hour_wait_release();
{
    Button_Hour_EnableInterrupt();
}

void button_debounce() // TODO: запихнути в button_hour_wait_release(); та button_minute_wait_release();
{
    delay_ms(100);
}