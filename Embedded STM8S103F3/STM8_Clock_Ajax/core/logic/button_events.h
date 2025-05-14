#pragma once

#include <stdint.h>

/**
 * @brief Struct representing Button identifiers.
 */
typedef enum
{
    BUTTON_NONE,
    BUTTON_HOUR,
    BUTTON_MINUTE,
    BUTTON_BOTH
} ButtonId;

/**
 * @brief Struct representing Event types.
 */
typedef enum
{
    BUTTON_EVENT_NONE,
    BUTTON_EVENT_CLICK
    // BUTTON_EVENT_DOUBLE_CLICK, ///< not yet implemented
    // BUTTON_EVENT_LONG_PRESS,   ///< not yet implemented
    // BUTTON_EVENT_RELEASE       ///< not yet implemented
} ButtonEventType;

/**
 * @brief Struct representing Button identifiers and Event types.
 */
typedef struct
{
    ButtonId button;
    ButtonEventType type;
} ButtonEvent;

/**
 * @brief Polls the button state and returns the next event if any.
 *
 * @return ButtonEvent structure
 */
ButtonEvent button_poll_event(void);