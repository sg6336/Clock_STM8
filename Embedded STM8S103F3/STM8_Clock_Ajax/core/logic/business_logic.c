// =============================================================================
//     Includes
// =============================================================================
#include "business_logic.h"
#include "button_events.h"
// #include "button_handlers.h"
// #include "exti_watchdog.h"
#include "system_init.h"

#include "clock.h"
// #include "display.h"
// #include "logger.h"
// #include "input.h"

// =============================================================================
//     Static Variables
// =============================================================================
static uint8_t _is_setting_time = 0;

// =============================================================================
//     Static Function Prototypes
// =============================================================================
static void _handle_user_input(void);
static void _toggle_time_setting_mode(void);

// ============================================================================
//     Public API functions
// ============================================================================
void business_logic_loop(void)
{
    init_hardware();

    while (1)
    {
        _handle_user_input(); // update display, log, etc.
    }
}

// ============================================================================
//     Static internal functions
// ============================================================================
/**
 * @brief Handle user input events and update application state.
 *
 * Processes button presses for hour and minute adjustments,
 * updates the display accordingly, and performs periodic
 * EXTI watchdog polling to ensure interrupt functionality.
 *
 * @return None.
 *
 * @note Called in each iteration of the main loop.
 * @note Relies on handlers from button_handlers and exti_watchdog modules.
 *
 * @see handle_hour_button, handle_minute_button, handle_both_buttons, exti_watchdog_poll
 */
static void _handle_user_input(void)
{
    ButtonEvent evt = button_poll_event();

    if (evt.type == BUTTON_EVENT_NONE)
    {
        // logger_write("Event NOT received\r\n");
        if (!_is_setting_time)
        {
            get_time_from_clock(); // sync_time_from_ds3231();
        }
        update_display_time(current_time.hours, current_time.minutes, current_time.seconds);
        return;
    }

    if (evt.type == BUTTON_EVENT_CLICK)
    {
        // logger_write("BUTTON_EVENT_CLICK\r\n");
        if (evt.button == BUTTON_HOUR && _is_setting_time)
        {
            logger_write("add_one_hour()\r\n");
            add_one_hour();
        }

        if (evt.button == BUTTON_MINUTE && _is_setting_time)
        {
            logger_write("add_one_minute()\r\n");
            add_one_minute();
        }

        if (evt.button == BUTTON_BOTH)
        {
            logger_write("BUTTON_BOTH\r\n");
            _toggle_time_setting_mode();
            display_show_wait_indicator();
        }
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
static void _toggle_time_setting_mode(void)
{
    _is_setting_time = !_is_setting_time;
    if (_is_setting_time)
    {
        current_time.seconds = 0;
        set_brightness_display_high();
    }
    if (!_is_setting_time)
    {
        set_time_to_clock();
        set_brightness_display_low();
    }
}
