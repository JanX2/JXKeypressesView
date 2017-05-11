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


static event_t EventKeyToEventNameMap[EventID_COUNT] = { [0 ... (EventID_COUNT - 1)] = E_Invalid};


EventKey eventKeyForEventTransition(KeysArrayType transitionType,
									KeyFlag transitionKey,
									KeyFlag beforeKeyFlags) {
	EventKey key = 0;
	key |= (transitionType & bool_MASK) << KeyFlags_BIT_COUNT * 2;
	key |= (transitionKey & KeyFlags_MASK) << KeyFlags_BIT_COUNT;
	key |= (beforeKeyFlags & KeyFlags_MASK);
	
	assert(key < EventID_COUNT);
	
	return key;
}

EventKey eventKeyForEvent(EventComponents event) {
	return eventKeyForEventTransition(event.transitionType,
									  event.transitionKey,
									  event.beforeKeyFlags);
}

KeyCodeType keyCodeForSingleKeyFlag(KeyFlag transitionKey) {
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

KeyFlag keyFlagForKeyCode(KeyCodeType keyCode) {
	KeyFlag transitionKey = KeyFlag_None;
	
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
		
		KeyFlag expectedKeyFlags = event.beforeKeyFlags ^ event.transitionKey;
		assert(event.afterKeyFlags == expectedKeyFlags);
		
		assert(keyCodeForSingleKeyFlag(event.transitionKey) == event.transitionKeyCode);
		
		assert(event.beforeKeyFlags == event.beforeBinary);
		assert(event.afterKeyFlags == event.afterBinary);
		
		assert(event.eventName == event.eventIndex);
		
		// Add Map entry.
		EventKey key = eventKeyForEvent(event);

		EventKeyToEventNameMap[key] = event.eventName;
	}
}

event_t eventNameForEventTransition(KeysArrayType transitionType,
									KeyFlag transitionKey,
									KeyFlag beforeKeyFlags) {
	
	EventKey key = eventKeyForEventTransition(transitionType,
											  transitionKey,
											  beforeKeyFlags);
	
	const event_t eventName = EventKeyToEventNameMap[key];
	return eventName;
}
