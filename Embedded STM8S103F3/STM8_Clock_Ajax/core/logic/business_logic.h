#pragma once

/**
 * @brief Main application loop for business logic.
 *
 * Initializes hardware and enters an infinite loop
 * handling input, updating display, and processing user events.
 *
 * @return None.
 *
 * @note Must be called from `main()` after system startup.
 *
 * @see system_init.h, button_handlers.h, exti_watchdog.h
 */
void business_logic_loop(void);
