//
//  JXKeypressesToEventNames.h
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 02.05.17.
//
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

typedef uint8_t JXJKLEventKey;

typedef struct {
	JXKeyState		transitionType;
	JXKeyFlag		transitionKey;
	JXKeyFlag		beforeKeyFlags;
	JXKeyFlag		afterKeyFlags;
	JXJKLEvent		eventName;
	JXKeyCode		transitionKeyCode;
	const char		*beforeVisual;
	const char		*afterVisual;
	JXJKLEventKey	beforeBinary;
	JXJKLEventKey	afterBinary;
	JXJKLEvent		eventIndex;
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

JXJKLEvent eventNameForEventTransition(JXKeyState transitionType,
									   JXKeyFlag transitionKey,
									   JXKeyFlag beforeKeyFlags);

/*
 Copyright 2017 Jan Weiß
 
 Some rights reserved: https://opensource.org/licenses/BSD-3-Clause
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in
    the documentation and/or other materials provided with the
    distribution.
 
 3. Neither the name of the copyright holder nor the names of any
    contributors may be used to endorse or promote products derived
    from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
