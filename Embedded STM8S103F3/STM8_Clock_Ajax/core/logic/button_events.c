// =============================================================================
//     Includes
// =============================================================================
#include "button_events.h"
#include "input.h"
#include "logger.h"

// =============================================================================
//     Static Function Prototypes
// =============================================================================
static void _enable_button_interrupts(void);

// ============================================================================
//     Public API functions
// ============================================================================
ButtonEvent button_poll_event(void)
{
    ButtonEvent evt = {BUTTON_NONE, BUTTON_EVENT_NONE};
    _enable_button_interrupts();

    // -------- Hour button --------
    if (button_hour_is_pressed())
    {
        logger_write("button_hour_is_pressed()\r\n");
        evt.button = BUTTON_HOUR;
        evt.type = BUTTON_EVENT_CLICK;

        if (button_minute_is_pressed())
        {
            // logger_write("Button_BothPressed()\r\n");
            evt.button = BUTTON_BOTH;
            evt.type = BUTTON_EVENT_CLICK;
            return evt;
        }
        return evt;
    }

    // -------- Minute button --------
    if (button_minute_is_pressed())
    {
        logger_write("button_minute_is_pressed()\r\n");
        evt.button = BUTTON_MINUTE;
        evt.type = BUTTON_EVENT_CLICK;

        if (button_hour_is_pressed())
        {
            // logger_write("Button_BothPressed()\r\n");
            evt.button = BUTTON_BOTH;
            evt.type = BUTTON_EVENT_CLICK;
            return evt;
        }
        return evt;
    }

    return evt;
}

// ============================================================================
//     Static internal functions
// ============================================================================
static void _enable_button_interrupts()
{
    button_enable_minute_interrupt();
    button_enable_hour_interrupt();
}
