//
//  JXKeypressesView.m
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 03.03.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#import "JXKeypressesView.h"

#include <unordered_set>


@interface JXKeypressesView () {
	std::unordered_set<unichar> pressedKeys;
}

@end

@implementation JXKeypressesView

- (void)keyDown:(NSEvent *)theEvent
{
	NSString *pressedKeyString = theEvent.charactersIgnoringModifiers;
	unichar   pressedKey = (pressedKeyString.length > 0) ? [pressedKeyString characterAtIndex:0] : 0;
	if (pressedKey)
		pressedKeys.insert(pressedKey);
}

- (void)keyUp:(NSEvent *)theEvent
{
	NSString *pressedKeyString = theEvent.charactersIgnoringModifiers;
	unichar   pressedKey = (pressedKeyString.length > 0) ? [pressedKeyString characterAtIndex:0] : 0;
	if (pressedKey) {
		auto foundKey = pressedKeys.find(pressedKey);
		if (foundKey != pressedKeys.end())
			pressedKeys.erase(foundKey);
	}
}

#if 0
// We need key codes under which to save the modifiers in our "keys pressed"
//	table. We must pick characters that are unlikely to be on any real keyboard.
//	So we pick the Unicode glyphs that correspond to the symbols on these keys.
enum {
	ICGShiftFunctionKey = 0x21E7, // -> NSShiftKeyMask
	ICGAlphaShiftFunctionKey = 0x21EA, // -> NSAlphaShiftKeyMask
	ICGAlternateFunctionKey = 0x2325, // -> NSAlternateKeyMask
	ICGControlFunctionKey = 0x2303, // -> NSControlKeyMask
	ICGCommandFunctionKey = 0x2318 // -> NSCommandKeyMask
};

- (void)flagsChanged:(NSEvent *)theEvent
{
	if (theEvent.modifierFlags & NSShiftKeyMask) {
		pressedKeys.insert(ICGShiftFunctionKey);
	}
	else {
		auto foundKey = pressedKeys.find(ICGShiftFunctionKey);
		if (foundKey != pressedKeys.end())
			pressedKeys.erase(foundKey);
	}

	if (theEvent.modifierFlags & NSAlphaShiftKeyMask) {
		pressedKeys.insert(ICGAlphaShiftFunctionKey);
	}
	else {
		auto foundKey = pressedKeys.find(ICGAlphaShiftFunctionKey);
		if (foundKey != pressedKeys.end())
			pressedKeys.erase(foundKey);
	}

	if (theEvent.modifierFlags & NSControlKeyMask) {
		pressedKeys.insert(ICGControlFunctionKey);
	}
	else {
		auto foundKey = pressedKeys.find(ICGControlFunctionKey);
		if (foundKey != pressedKeys.end())
			pressedKeys.erase(foundKey);
	}

	if (theEvent.modifierFlags & NSCommandKeyMask) {
		pressedKeys.insert(ICGCommandFunctionKey);
	}
	else {
		auto foundKey = pressedKeys.find(ICGCommandFunctionKey);
		if (foundKey != pressedKeys.end())
			pressedKeys.erase(foundKey);
	}

	if (theEvent.modifierFlags & NSAlternateKeyMask) {
		pressedKeys.insert(ICGAlternateFunctionKey);
	}
	else {
		auto foundKey = pressedKeys.find(ICGAlternateFunctionKey);
		if (foundKey != pressedKeys.end())
			pressedKeys.erase(foundKey);
	}
}

- (void)dispatchPressedKeys:(NSTimer *)sender
{
	BOOL shiftKeyDown = pressedKeys.find(ICGShiftFunctionKey) != pressedKeys.end();
	for (unichar pressedKey : pressedKeys) {
		switch (pressedKey) {
		case 'w':
				//[self moveUp:self fast:shiftKeyDown];
			break;
				//...
		}
	}
}
#endif

@end
