//
//  JXKeypressesToEventNames.h
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 02.05.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#pragma once

#include <stdbool.h>
#include <stdint.h>

#include "JXKeypressesDefinitions.h"

typedef enum {
	KeyFlag_None = 0b000,
	KeyFlag_L	 = 0b001,
	KeyFlag_K	 = 0b010,
	KeyFlag_J	 = 0b100,
	// For debugging:
	KeyFlag_KL	 = 0b011,
	KeyFlag_JL	 = 0b101,
	KeyFlag_JK	 = 0b110,
	
	KeyFlag_JKL	 = 0b111,

} JXKeyFlag;

typedef uint8_t JXEventKey;

typedef struct {
	KeysArrayType	transitionType;
	JXKeyFlag		transitionKey;
	JXKeyFlag		beforeKeyFlags;
	JXKeyFlag		afterKeyFlags;
	JXEvent			eventName;
	JXKeyCode		transitionKeyCode;
	const char		*beforeVisual;
	const char		*afterVisual;
	JXEventKey		beforeBinary;
	JXEventKey		afterBinary;
	JXEvent			eventIndex;
} EventComponents;

static const EventComponents EventComponentsToEventNameTable[E_Count] =
{
  /*{Transition Type, Transition Key, Before KeyFlags,         After KeyFlags,          Event Name,           Transition KeyCode, Before V, After V, Before B, After B, Event Index, },*/
	{KeyIsDown,       KeyFlag_J,      (KeyFlag_None),          (KeyFlag_J),             E_JDown_From___ToJ__, kVK_ANSI_J,         "▆▆▆",    "▃▆▆",   0b000,    0b100,   0,           },
	{KeyIsUp,         KeyFlag_K,      (KeyFlag_J | KeyFlag_K), (KeyFlag_J),             E_KUp_FromJK_ToJ__,   kVK_ANSI_K,         "▃▃▆",    "▃▆▆",   0b110,    0b100,   1,           },
	{KeyIsDown,       KeyFlag_J,      (KeyFlag_K),             (KeyFlag_J | KeyFlag_K), E_JDown_From_K_ToJK_, kVK_ANSI_J,         "▆▃▆",    "▃▃▆",   0b010,    0b110,   2,           },
	{KeyIsUp,         KeyFlag_J,      (KeyFlag_J | KeyFlag_K), (KeyFlag_K),             E_JUp_FromJK_To_K_,   kVK_ANSI_J,         "▃▃▆",    "▆▃▆",   0b110,    0b010,   3,           },
	{KeyIsDown,       KeyFlag_K,      (KeyFlag_None),          (KeyFlag_K),             E_KDown,              kVK_ANSI_K,         "▆▆▆",    "▆▃▆",   0b000,    0b010,   4,           },
  //{KeyIsDown,       KeyFlag_K,      (KeyFlag_None),          (KeyFlag_K),             E_KDown_From___To_K_, kVK_ANSI_K,         "▆▆▆",    "▆▃▆",   0b000,    0b010,   4,           },
	{KeyIsUp,         KeyFlag_L,      (KeyFlag_K | KeyFlag_L), (KeyFlag_K),             E_LUp_From_KLTo_K_,   kVK_ANSI_L,         "▆▃▃",    "▆▃▆",   0b011,    0b010,   5,           },
	{KeyIsDown,       KeyFlag_L,      (KeyFlag_K),             (KeyFlag_K | KeyFlag_L), E_LDown_From_K_To_KL, kVK_ANSI_L,         "▆▃▆",    "▆▃▃",   0b010,    0b011,   6,           },
	{KeyIsUp,         KeyFlag_K,      (KeyFlag_K | KeyFlag_L), (KeyFlag_L),             E_KUp_From_KLTo__L,   kVK_ANSI_K,         "▆▃▃",    "▆▆▃",   0b011,    0b001,   7,           },
	{KeyIsDown,       KeyFlag_L,      (KeyFlag_None),          (KeyFlag_L),             E_LDown_From___To__L, kVK_ANSI_L,         "▆▆▆",    "▆▆▃",   0b000,    0b001,   8,           },
  //{KeyIsDown,       KeyFlag_K,      (KeyFlag_J),             (KeyFlag_J | KeyFlag_K), E_KDown_FromJ__ToJK_, kVK_ANSI_K,         "▃▆▆",    "▃▃▆",   0b100,    0b110,   9,           },
  //{KeyIsDown,       KeyFlag_K,      (KeyFlag_L),             (KeyFlag_K | KeyFlag_L), E_KDown_From__LTo_KL, kVK_ANSI_K,         "▆▆▃",    "▆▃▃",   0b001,    0b011,   10,          },
};

JXKeyCode keyCodeForSingleKeyFlag(JXKeyFlag transitionKey);
JXKeyFlag keyFlagForKeyCode(JXKeyCode keyCode);

JXEvent eventNameForEventTransition(KeysArrayType transitionType,
									JXKeyFlag transitionKey,
									JXKeyFlag beforeKeyFlags);