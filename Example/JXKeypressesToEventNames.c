//
//  JXKeypressesToEventNames.c
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 02.05.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#include "JXKeypressesToEventNames.h"

#include <assert.h>


#define KeyFlags_BIT_COUNT	3

#define bool_MASK		0b00000001
#define KeyFlags_MASK	0b00000111

#define EventID_USED_BIT_COUNT	(1 + KeyFlags_BIT_COUNT * 2)
#define EventID_COUNT			(1 << EventID_USED_BIT_COUNT)

_Static_assert((E_Count <= EventID_COUNT), "E_Count needs to fit within EventID_COUNT");


static JXEvent EventKeyToEventNameMap[EventID_COUNT] = { [0 ... (EventID_COUNT - 1)] = E_Invalid};


JXEventKey eventKeyForEventTransition(KeysArrayType transitionType,
									  JXKeyFlag transitionKey,
									  JXKeyFlag beforeKeyFlags) {
	JXEventKey key = 0;
	key |= (JXEventKey)(transitionType & bool_MASK) << KeyFlags_BIT_COUNT * 2;
	key |= (JXEventKey)(transitionKey & KeyFlags_MASK) << KeyFlags_BIT_COUNT;
	key |= (JXEventKey)(beforeKeyFlags & KeyFlags_MASK);
	
	assert(key < EventID_COUNT);
	
	return key;
}

JXEventKey eventKeyForEvent(EventComponents event) {
	return eventKeyForEventTransition(event.transitionType,
									  event.transitionKey,
									  event.beforeKeyFlags);
}

KeyCodeType keyCodeForSingleKeyFlag(JXKeyFlag transitionKey) {
	KeyCodeType transitionKeyCode = KeyCodeUndefined;
	
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

JXKeyFlag keyFlagForKeyCode(KeyCodeType keyCode) {
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
		KeysArrayType expectedTransitionType = (bool)(event.afterKeyFlags & event.transitionKey);
		assert(expectedTransitionType == event.transitionType);
		
		JXKeyFlag expectedKeyFlags = event.beforeKeyFlags ^ event.transitionKey;
		assert(event.afterKeyFlags == expectedKeyFlags);
		
		assert(keyCodeForSingleKeyFlag(event.transitionKey) == event.transitionKeyCode);
		
		assert(event.beforeKeyFlags == event.beforeBinary);
		assert(event.afterKeyFlags == event.afterBinary);
		
		assert(event.eventName == event.eventIndex);
		
		// Add Map entry.
		JXEventKey key = eventKeyForEvent(event);

		EventKeyToEventNameMap[key] = event.eventName;
		assert(EventKeyToEventNameMap[key] == event.eventName);
	}
}

JXEvent eventNameForEventTransition(KeysArrayType transitionType,
									JXKeyFlag transitionKey,
									JXKeyFlag beforeKeyFlags) {
	
	if ((transitionType == KeyIsDown) &&
		(transitionKey == KeyFlag_K)) {
		return E_KDown;
	}
	
	JXEventKey key = eventKeyForEventTransition(transitionType,
											  transitionKey,
											  beforeKeyFlags);
	
	const JXEvent eventName = EventKeyToEventNameMap[key];
	return eventName;
}


#if 0
void testEventKeyForEventTransition() __attribute__ ((constructor));
void testEventKeyForEventTransition() {
	JXEventKey key;
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
	JXEventKey key;
	JXEvent eventName;
	
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