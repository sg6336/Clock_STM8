// =============================================================================
//     Includes
// =============================================================================
#include "logger.h"

#ifdef LOGGER_USE_UART
#include "uartTX.h"

// ============================================================================
//     Public API functions
// ============================================================================

void logger_init(void) // Initialize UART TX only, PD5, 9600 baud
{
    // Initialize UART
    uart_init(); // TX only, PD5, 9600 baud
}

void logger_write(const char *msg)
{
    uart_write(msg);
}
#else
// ============================================================================
//     Stub functions
// ============================================================================

void logger_init(void)
{
}

void logger_write(const char *msg)
{
}
#endif
