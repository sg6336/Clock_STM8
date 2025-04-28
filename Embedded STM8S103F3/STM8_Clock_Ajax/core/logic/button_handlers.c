
// =============================================================================
//     Includes
// =============================================================================
#include "button_handlers.h"
#include "clock.h"
#include "display.h"
#include "logger.h"
#include "input.h"

// =============================================================================
//     Defines
// =============================================================================
#define HOURS_IN_DAY 24
#define MINUTES_IN_HOUR 60

// =============================================================================
//     Static Variables
// =============================================================================
static uint8_t is_setting_time = 0;

// =============================================================================
//     Static Function Prototypes
// =============================================================================
static void toggle_time_setting_mode(void);

// ============================================================================
//     Public API functions
// ============================================================================
/**
 * @brief Handle logic for when the Hour button is pressed.
 *
 * Increments hour or reacts to simultaneous press of both buttons
 * (first Hour, then Minute).
 */
void handle_hour_button()
{
    if (button_hour_is_pressed())
    {
        button_debounce(); // TODO: запихнути в button_hour_is_pressed()

        if (button_both_is_pressed_first_hour_second_minute())
        {
            logger_write("Both buttons are pressed after Hour button\r\n");
            toggle_time_setting_mode();
            display_show_wait_indicator();

            // Wait for Minute button release after dual press
            button_minute_wait_release();
            // clear flag if still set
            button_clear_minute_flag();       // TODO: запихнути в button_minute_wait_release();
            button_debounce();                // TODO: запихнути в button_minute_wait_release();
            button_enable_minute_interrupt(); // TODO: запихнути в button_minute_wait_release();
        }
        else
        {
            logger_write("Hour button pressed\r\n");

            // TODO: add_one_hour();

            if (is_setting_time)
            {
                current_time.hours++;
                current_time.hours %= HOURS_IN_DAY;
            }
        }

        button_hour_wait_release();
        button_debounce();              // TODO: запихнути в button_hour_wait_release();
        button_enable_hour_interrupt(); // TODO: запихнути в button_hour_wait_release();
    }
}

/**
 * @brief Handle logic for when the Minute button is pressed.
 *
 * Increments minutes or reacts to simultaneous press of both buttons
 * (first Minute, then Hour).
 */
void handle_minute_button()
{
    if (button_minute_is_pressed())
    {
        button_debounce();

        if (button_both_is_pressed_first_minute_second_hour())
        {
            logger_write("Both buttons are pressed after Min button\r\n");
            toggle_time_setting_mode();
            display_show_wait_indicator();

            // Wait for Hour button release after dual press
            button_hour_wait_release();
            // clear flag if still set
            button_clear_hour_flag();       // TODO: запихнути в button_hour_wait_release();
            button_debounce();              // TODO: запихнути в button_hour_wait_release();
            button_enable_hour_interrupt(); // TODO: запихнути в button_hour_wait_release();
        }
        else
        {
            logger_write("Minute button pressed\r\n");

            // TODO: add_one_minute();

            if (is_setting_time)
            {
                current_time.minutes++;
                current_time.minutes %= MINUTES_IN_HOUR;
            }
        }

        button_minute_wait_release();
        button_debounce();
        button_enable_minute_interrupt();
    }
}

void handle_both_buttons(void)
{
    if (button_both_is_released())
    {
        if (!is_setting_time)
        {
            get_time_from_clock(); // sync_time_from_ds3231();
        }

        update_display_time(current_time.hours, current_time.minutes, current_time.seconds);
    }
}

// ============================================================================
//     Static internal functions
// ============================================================================
/**
 * @brief Toggle the time setting mode flag.
 *
 * If entering time setting mode:
 *   - Set seconds to 0
 *   - Increase display brightness
 *
 * If exiting time setting mode:
 *   - Save adjusted time to DS3231
 *   - Restore normal brightness
 */
static void toggle_time_setting_mode(void)
{
    is_setting_time = !is_setting_time;
    if (is_setting_time)
    {
        current_time.seconds = 0;
        set_brightness_display_high();
    }
    if (!is_setting_time)
    {
        set_time_to_clock();
        set_brightness_display_low();
    }
}