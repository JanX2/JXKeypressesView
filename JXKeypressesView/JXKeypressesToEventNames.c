//
//  JXKeypressesToEventNames.c
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 02.05.17.
//
//

#include "JXKeypressesToEventNames.h"

#include <assert.h>


#define KeyFlags_BIT_COUNT	3

#define bool_MASK		0b00000001
#define KeyFlags_MASK	0b00000111

#define EventID_USED_BIT_COUNT	(1 + KeyFlags_BIT_COUNT * 2)
#define EventID_COUNT			(1 << EventID_USED_BIT_COUNT)

_Static_assert((E_Count <= EventID_COUNT), "E_Count needs to fit within EventID_COUNT");


static JXJKLEvent EventKeyToEventNameMap[EventID_COUNT] = { [0 ... (EventID_COUNT - 1)] = E_Invalid};


JXJKLEventKey eventKeyForEventTransition(JXKeyState transitionType,
										 JXKeyFlag transitionKey,
										 JXKeyFlag beforeKeyFlags) {
	JXJKLEventKey key = 0;
	key |= (JXJKLEventKey)(transitionType & bool_MASK) << KeyFlags_BIT_COUNT * 2;
	key |= (JXJKLEventKey)(transitionKey & KeyFlags_MASK) << KeyFlags_BIT_COUNT;
	key |= (JXJKLEventKey)(beforeKeyFlags & KeyFlags_MASK);
	
	assert(key < EventID_COUNT);
	
	return key;
}

JXJKLEventKey eventKeyForEvent(EventComponents event) {
	return eventKeyForEventTransition(event.transitionType,
									  event.transitionKey,
									  event.beforeKeyFlags);
}

JXKeyCode keyCodeForSingleKeyFlag(JXKeyFlag transitionKey) {
	JXKeyCode transitionKeyCode = JXKeyCodeUndefined;
	
	switch (transitionKey) {
		case KeyFlag_L:
			transitionKeyCode = kVK_ANSI_L;
			break;
			
		case KeyFlag_K:
			transitionKeyCode = kVK_ANSI_K;
			break;
			
		case KeyFlag_J:
			transitionKeyCode = kVK_ANSI_J;
			break;
			
		case KeyFlag_None:
		default:
			assert(false);
			break;
	}
	
	return transitionKeyCode;
}

JXKeyFlag keyFlagForKeyCode(JXKeyCode keyCode) {
	JXKeyFlag transitionKey = KeyFlag_None;
	
	switch (keyCode) {
		case kVK_ANSI_L:
			transitionKey = KeyFlag_L;
			break;
			
		case kVK_ANSI_K:
			transitionKey = KeyFlag_K;
			break;
			
		case kVK_ANSI_J:
			transitionKey = KeyFlag_J;
			break;
			
		default:
			assert(false);
			break;
	}
	
	return transitionKey;
}

// Generate EventKeyToEventNameMap from EventComponentsToEventNameTable by iterating over it,
// acquiring the hash/ID/key for each entry and setting its Event Name in the map.
void generateEventKeyToEventNameMap() __attribute__ ((constructor));
void generateEventKeyToEventNameMap() {
	for (size_t i = 0; i < E_Count; i += 1) {
		EventComponents event = EventComponentsToEventNameTable[i];
		
		// Check table consistency.
		JXKeyState expectedTransitionType = (bool)(event.afterKeyFlags & event.transitionKey);
		assert(expectedTransitionType == event.transitionType);
		
		JXKeyFlag expectedKeyFlags = event.beforeKeyFlags ^ event.transitionKey;
		assert(event.afterKeyFlags == expectedKeyFlags);
		
		assert(keyCodeForSingleKeyFlag(event.transitionKey) == event.transitionKeyCode);
		
		assert(event.beforeKeyFlags == event.beforeBinary);
		assert(event.afterKeyFlags == event.afterBinary);
		
		assert(event.eventName == event.eventIndex);
		
		// Add Map entry.
		JXJKLEventKey key = eventKeyForEvent(event);

		EventKeyToEventNameMap[key] = event.eventName;
		assert(EventKeyToEventNameMap[key] == event.eventName);
	}
}

JXJKLEvent eventNameForEventTransition(JXKeyState transitionType,
									   JXKeyFlag transitionKey,
									   JXKeyFlag beforeKeyFlags) {
	
	if ((transitionType == KeyIsDown) &&
		(transitionKey == KeyFlag_K)) {
		return E_KDown;
	}
	
	JXJKLEventKey key = eventKeyForEventTransition(transitionType,
												   transitionKey,
												   beforeKeyFlags);
	
	const JXJKLEvent eventName = EventKeyToEventNameMap[key];
	return eventName;
}


#if 0
void testEventKeyForEventTransition() __attribute__ ((constructor));
void testEventKeyForEventTransition() {
	JXJKLEventKey key;
	key = eventKeyForEventTransition(KeyIsUp,
									 KeyFlag_K,
									 KeyFlag_JK);
	
	assert(key == 0b00010110);
	
	key = eventKeyForEventTransition(KeyIsDown,
									 KeyFlag_K,
									 KeyFlag_L);
	
	assert(key == 0b01010001);
	
	key = eventKeyForEventTransition(KeyIsDown,
									 KeyFlag_L,
									 KeyFlag_K);
	
	assert(key == 0b01001010);
}

void testEventKeyToEventNameMap() __attribute__ ((constructor));
void testEventKeyToEventNameMap() {
	JXJKLEventKey key;
	JXJKLEvent eventName;
	
	key = 0b00010110;
	eventName = EventKeyToEventNameMap[key];
	assert(eventName == E_KUp_FromJK_ToJ__);

	/*
	// Handled by generic treatment of KDown in `eventNameForEventTransition()`.
	key = 0b01010001;
	eventName = EventKeyToEventNameMap[key];
	assert(eventName == E_KDown);
	*/
	
	key = 0b01001010;
	eventName = EventKeyToEventNameMap[key];
	assert(eventName == E_LDown_From_K_To_KL);
}

#endif

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
