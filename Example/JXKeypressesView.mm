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
	unichar   pressedKey = (pressedKeyString.length > 0) ? [pressedKeyString characterAtIndex:0] : '\0';
	if (pressedKey != '\0') {
		pressedKeys.insert(pressedKey);
	}
}

- (void)keyUp:(NSEvent *)theEvent
{
	NSString *pressedKeyString = theEvent.charactersIgnoringModifiers;
	unichar   pressedKey = (pressedKeyString.length > 0) ? [pressedKeyString characterAtIndex:0] : '\0';
	if (pressedKey != '\0') {
		auto foundKey = pressedKeys.find(pressedKey);
		if (foundKey != pressedKeys.end()) {
			pressedKeys.erase(foundKey);
		}
	}
}

#if 0
// We need key codes under which to save the modifiers in our "keys pressed"
//	table. We must pick characters that are unlikely to be on any real keyboard.
//	So we pick the Unicode glyphs that correspond to the symbols on these keys.
enum {
	JXKShiftFunctionKey			= 0x21E7, // -> NSShiftKeyMask
	JXKAlphaShiftFunctionKey	= 0x21EA, // -> NSAlphaShiftKeyMask
	JXKAlternateFunctionKey		= 0x2325, // -> NSAlternateKeyMask
	JXKControlFunctionKey		= 0x2303, // -> NSControlKeyMask
	JXKCommandFunctionKey		= 0x2318  // -> NSCommandKeyMask
};

#if 0
// From
// MacOSX10.11.sdk/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/Headers/Events.h
/* useful Unicode code points*/
enum {
	kShiftUnicode                 = 0x21E7, /* Unicode UPWARDS WHITE ARROW*/
	kControlUnicode               = 0x2303, /* Unicode UP ARROWHEAD*/
	kOptionUnicode                = 0x2325, /* Unicode OPTION KEY*/
	kCommandUnicode               = 0x2318, /* Unicode PLACE OF INTEREST SIGN*/
	kPencilUnicode                = 0x270E, /* Unicode LOWER RIGHT PENCIL; actually pointed left until Mac OS X 10.3*/
	kPencilLeftUnicode            = 0xF802, /* Unicode LOWER LEFT PENCIL; available in Mac OS X 10.3 and later*/
	kCheckUnicode                 = 0x2713, /* Unicode CHECK MARK*/
	kDiamondUnicode               = 0x25C6, /* Unicode BLACK DIAMOND*/
	kBulletUnicode                = 0x2022, /* Unicode BULLET*/
	kAppleLogoUnicode             = 0xF8FF /* Unicode APPLE LOGO*/
};
#endif

- (void)flagsChanged:(NSEvent *)theEvent
{
	if (theEvent.isARepeat)  return;
	
	if (theEvent.modifierFlags & NSShiftKeyMask) {
		pressedKeys.insert(JXKShiftFunctionKey);
	}
	else {
		auto foundKey = pressedKeys.find(JXKShiftFunctionKey);
		if (foundKey != pressedKeys.end())
			pressedKeys.erase(foundKey);
	}

	if (theEvent.modifierFlags & NSAlphaShiftKeyMask) {
		pressedKeys.insert(JXKAlphaShiftFunctionKey);
	}
	else {
		auto foundKey = pressedKeys.find(JXKAlphaShiftFunctionKey);
		if (foundKey != pressedKeys.end())
			pressedKeys.erase(foundKey);
	}

	if (theEvent.modifierFlags & NSControlKeyMask) {
		pressedKeys.insert(JXKControlFunctionKey);
	}
	else {
		auto foundKey = pressedKeys.find(JXKControlFunctionKey);
		if (foundKey != pressedKeys.end())
			pressedKeys.erase(foundKey);
	}

	if (theEvent.modifierFlags & NSCommandKeyMask) {
		pressedKeys.insert(JXKCommandFunctionKey);
	}
	else {
		auto foundKey = pressedKeys.find(JXKCommandFunctionKey);
		if (foundKey != pressedKeys.end())
			pressedKeys.erase(foundKey);
	}

	if (theEvent.modifierFlags & NSAlternateKeyMask) {
		pressedKeys.insert(JXKAlternateFunctionKey);
	}
	else {
		auto foundKey = pressedKeys.find(JXKAlternateFunctionKey);
		if (foundKey != pressedKeys.end())
			pressedKeys.erase(foundKey);
	}
}
#endif

#if 0
- (void)dispatchPressedKeys:(NSTimer *)sender
{
	BOOL shiftKeyDown = pressedKeys.find(JXKShiftFunctionKey) != pressedKeys.end();
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
