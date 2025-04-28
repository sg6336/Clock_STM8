// =============================================================================
//     Includes
// =============================================================================
#include "business_logic.h"
#include "button_handlers.h"
#include "exti_watchdog.h"
#include "system_init.h"

// =============================================================================
//     Static Function Prototypes
// =============================================================================
static void handle_user_input(void);

// ============================================================================
//     Public API functions
// ============================================================================
void business_logic_loop(void)
{
    init_hardware();

    while (1)
    {
        handle_user_input(); // update display, log, etc.
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
static void handle_user_input(void)
{
    handle_hour_button();
    handle_minute_button();
    handle_both_buttons();

    exti_watchdog_poll(); // ← чистий виклик
}
