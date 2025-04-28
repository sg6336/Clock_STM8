// =============================================================================
//     Includes
// =============================================================================
#include "exti_watchdog.h"
#include "button.h"

// ============================================================================
//     Public API functions
// ============================================================================
void exti_watchdog_poll()
{
    // Watchdog-style recovery for EXTI — re-enables interrupts if stuck
    Button_Hour_EnsureInterruptEnabled();
    Button_Minute_EnsureInterruptEnabled();
}
