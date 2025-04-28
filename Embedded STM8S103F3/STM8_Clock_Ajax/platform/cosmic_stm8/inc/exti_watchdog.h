#pragma once

/**
 * @brief Polls the button states and re-enables EXTI if necessary.
 *
 * Should be called periodically in the main loop to maintain EXTI functionality
 * in case of missed or stuck interrupts.
 *
 * @return None.
 *
 * @note Helps recover from missed EXTI triggers caused by noise or glitches.
 *
 * @see button.h — for Button_Hour_EnsureInterruptEnabled and Button_Minute_EnsureInterruptEnabled.
 */
void exti_watchdog_poll(void);