// =============================================================================
//     Includes
// =============================================================================
#include "logger.h"
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
