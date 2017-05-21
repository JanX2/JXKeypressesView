//
//  JXKeypressesView.m
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 03.03.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#import "JXKeypressesView.h"

#import "JXJKLStateMachine.h"
#import "JXKeypressesDefinitions.h"
#import "JXKeypressesToEventNames.h"
#import "TSCDocument.h"


#define ENABLE_BINDINGS	1

// NOTE: We are using key codes here, because we want to use keys located
// in the same place on every keyboard regardless of layout.


const JXKeyCode KeyCodeMax = 0x7E;
const JXKeyCode KeyCodeCount = KeyCodeMax + 1;


JXKeyState * handledKeys() {
	static dispatch_once_t OnceToken;
	static JXKeyState handledKeys[KeyCodeCount];
	
	dispatch_once(&OnceToken, ^{
		handledKeys[kVK_ANSI_J]		= KeyIsHandled;
		handledKeys[kVK_Space]		= KeyNotHandled;
		handledKeys[kVK_ANSI_K]		= KeyIsHandled;
		handledKeys[kVK_ANSI_L]		= KeyIsHandled;
#if 0
		handledKeys[kVK_ANSI_I]		= KeyNotHandled;
		handledKeys[kVK_ANSI_O]		= KeyNotHandled;
#else
		handledKeys[kVK_ANSI_I]		= KeyIsHandled;
		handledKeys[kVK_ANSI_O]		= KeyIsHandled;
#endif
		// All other keys are (implictly) not handled.
	});
	
	return handledKeys;
}


@interface JXKeypressesView () {
	JXKeyState _keysDown[KeyCodeCount];
}

@end


@implementation JXKeypressesView {
	JXJKLStateMachine *_stateMachine;
}


# pragma mark Object lifecycle

- (instancetype)init
{
	self = [super init];
	
	if (self) {
		[self initKeypressesView];
	}
	
	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	[self initKeypressesView];
}

- (void)initKeypressesView
{
	[self willChangeValueForKey:@"document"];
	self->_document = [TSCDocument new];
	[self didChangeValueForKey:@"document"];
	
	_stateMachine = [[JXJKLStateMachine alloc] initWithTarget:self->_document];
}

# pragma mark Event Handling

JXKeyFlag keyFlagsForKeysArray(JXKeyState *keysArray) {
	JXKeyFlag keyFlags = KeyFlag_None |
	((keysArray[kVK_ANSI_J] == KeyIsDown) ? KeyFlag_J : KeyFlag_None) |
	((keysArray[kVK_ANSI_K] == KeyIsDown) ? KeyFlag_K : KeyFlag_None) |
	((keysArray[kVK_ANSI_L] == KeyIsDown) ? KeyFlag_L : KeyFlag_None);
	
	return keyFlags;
}

bool processEventUsingStateMachine(JXKeyCode keyCode,
								   JXKeyState *keysDown,
								   JXKeyState transitionType,
								   JXJKLStateMachine *stateMachine) {
	JXKeyFlag transitionKey = keyFlagForKeyCode(keyCode);
	JXKeyFlag beforeKeyFlags = keyFlagsForKeysArray(keysDown);
	
	bool allThreeKeysDown =
	((beforeKeyFlags | transitionKey) == KeyFlag_JKL);
	
	if (allThreeKeysDown) {
		beforeKeyFlags = KeyFlag_K;
	}
	
	JXEvent event = eventNameForEventTransition(transitionType,
												transitionKey,
												beforeKeyFlags);
	[stateMachine processEvent:event];
	
	return true;
}

- (void)keyDown:(NSEvent *)theEvent
{
	BOOL isARepeat = theEvent.isARepeat;
	NSUInteger flags = theEvent.modifierFlags & NSDeviceIndependentModifierFlagsMask;
	
	BOOL handledKey = NO;
	
	// We ignore repeat events, because they are
	// already covered by the state of `_keysDown[]`.
	if ((isARepeat == NO) &&
		(flags == 0)) { // We currently only want events without modifiers.
		
		JXKeyCode keyCode = theEvent.keyCode;
		JXKeyState transitionType = KeyIsDown;
		
		handledKey = (handledKeys()[keyCode] == KeyIsHandled);
		
		if (handledKey &&
			(keyCode <= KeyCodeMax)) {
			
			switch (keyCode) {
				case kVK_ANSI_J:
				case kVK_ANSI_K:
				case kVK_ANSI_L:
					if (processEventUsingStateMachine(keyCode, _keysDown, transitionType, _stateMachine) == false) {
						// We currently do this too early, as we change `_keysDown[keyCode]` afterwards
						// so that change below is not taken into account.
						[self resetStateMachine];
					}
					break;
					
				case kVK_Space:
					// Pause/play normally.
					break;
					
				case kVK_ANSI_I:
					break;
					
				case kVK_ANSI_O:
					break;
					
				default:
					//handledKey = NO;
					break;
			}
			
#if ENABLE_BINDINGS
			[self willChangeValueForKeyCode:keyCode];
#endif
			_keysDown[keyCode] = transitionType;
#if ENABLE_BINDINGS
			[self didChangeValueForKeyCode:keyCode];
#endif
			
		}
	}
	else if (isARepeat) {
		JXKeyCode keyCode = theEvent.keyCode;
		handledKey = (handledKeys()[keyCode] == KeyIsHandled);
	}
	
	if (handledKey == NO) {
		[super keyDown:theEvent];
	}
}

- (void)keyUp:(NSEvent *)theEvent
{
	BOOL isARepeat = theEvent.isARepeat;
	NSUInteger flags = theEvent.modifierFlags & NSDeviceIndependentModifierFlagsMask;
	
	BOOL handledKey = NO;
	
	// We clear `_keysDown[]` in `-flagsChanged:`.
	// Otherwise, this would break symmetry.
	// We ignore repeat events, because they are
	// already covered by the state of `_keysDown[]`.
	if ((isARepeat == NO) &&
		(flags == 0)) {
		
		JXKeyCode keyCode = theEvent.keyCode;
		JXKeyState transitionType = KeyIsUp;
		
		handledKey = (handledKeys()[keyCode] == KeyIsHandled);
		
		if (handledKey &&
			(keyCode <= KeyCodeMax)) {
			
			switch (keyCode) {
				case kVK_ANSI_J:
				case kVK_ANSI_K:
				case kVK_ANSI_L:
					if (processEventUsingStateMachine(keyCode, _keysDown, transitionType, _stateMachine) == false) {
						[self resetStateMachine];
					}
					break;
					
				case kVK_Space:
					// Do nothing.
					break;
					
				case kVK_ANSI_I:
					// Do nothing.
					break;
					
				case kVK_ANSI_O:
					// Do nothing.
					break;
					
				default:
					//handledKey = NO;
					break;
			}
			
#if ENABLE_BINDINGS
			[self willChangeValueForKeyCode:keyCode];
#endif
			_keysDown[keyCode] = transitionType;
#if ENABLE_BINDINGS
			[self didChangeValueForKeyCode:keyCode];
#endif
			
		}
	}
	else if (isARepeat) {
		JXKeyCode keyCode = theEvent.keyCode;
		handledKey = (handledKeys()[keyCode] == KeyIsHandled);
	}
	
	if (handledKey == NO) {
		[super keyUp:theEvent];
	}
}

#if ENABLE_BINDINGS
typedef void (*IMPForKeyCode)(JXKeypressesView *, SEL, JXKeyCode);

void messageSelectorForEveryHandledKeyCode(JXKeypressesView *keypressesView, SEL selectorForKeyCode) {
	IMPForKeyCode methodForKeyCode = (IMPForKeyCode)[keypressesView methodForSelector:selectorForKeyCode];
	
	JXKeyState *keys = handledKeys();
	for (JXKeyCode keyCode = 0; keyCode < KeyCodeCount; keyCode++) {
		JXKeyState handledKey = keys[keyCode];
		if (handledKey == KeyIsHandled) {
			methodForKeyCode(keypressesView, selectorForKeyCode, keyCode);
		}
	}
}
#endif

- (void)flagsChanged:(NSEvent *)theEvent
{
	NSUInteger flags = theEvent.modifierFlags & NSDeviceIndependentModifierFlagsMask;
	
	if (flags != 0) {
		[self resetStateMachine];
	}
}

- (void)resetStateMachine
{
	[self->_document pausePlayback:self];
}


#if 0
- (void)resetKeys
{
#if ENABLE_BINDINGS
	messageSelectorForEveryHandledKeyCode(self, @selector(willChangeValueForKeyCode:));
#endif
	
	// Simulate every key that is marked as down being released.
	JXKeyState transitionType = KeyIsUp;
	
	for (JXKeyCode keyCode = 0; keyCode < KeyCodeCount; keyCode++) {
		switch (keyCode) {
			case kVK_ANSI_J:
			case kVK_ANSI_K:
			case kVK_ANSI_L: {
				processEventUsingStateMachine(keyCode, _keysDown, transitionType, _stateMachine);
				break;
			}
				
			default:
				break;
		}
		
		_keysDown[keyCode] = KeyIsUp;
	}
	
#if ENABLE_BINDINGS
	messageSelectorForEveryHandledKeyCode(self, @selector(didChangeValueForKeyCode:));
#endif
}
#endif


#if ENABLE_BINDINGS

# pragma mark Bindings Support

- (id)valueForKey:(NSString *)key
{
	const void *value =
	CFDictionaryGetValue(propertyNames2KeyCodesOffsetBy1Dict(),
						 (__bridge const void *)key);
	
	if (value) {
		JXKeyCode keyCode = (JXKeyCode)(value - 1);
		
		BOOL isDown = _keysDown[keyCode];
		return @(isDown);
	}
	else {
		return [super valueForKey:key];
	}
}

NSString * const JXKUndefinedKeyCode = @"*undefined*";

NSArray * namesForKeyCodesArray() {
	static dispatch_once_t OnceToken;
	static NSArray *array = nil;
	
	dispatch_once(&OnceToken, ^{
		array =
		@[
		  @"a",					// 0x00
		  @"s",					// 0x01
		  @"d",					// 0x02
		  @"f",					// 0x03
		  @"h",					// 0x04
		  @"g",					// 0x05
		  @"z",					// 0x06
		  @"x",					// 0x07
		  @"c",					// 0x08
		  @"v",					// 0x09
		  @"isoSection",		// 0x0A
		  @"b",					// 0x0B
		  @"q",					// 0x0C
		  @"w",					// 0x0D
		  @"e",					// 0x0E
		  @"r",					// 0x0F
		  @"y",					// 0x10
		  @"t",					// 0x11
		  @"1",					// 0x12
		  @"2",					// 0x13
		  @"3",					// 0x14
		  @"4",					// 0x15
		  @"6",					// 0x16
		  @"5",					// 0x17
		  @"equal",				// 0x18
		  @"9",					// 0x19
		  @"7",					// 0x1A
		  @"minus",				// 0x1B
		  @"8",					// 0x1C
		  @"0",					// 0x1D
		  @"rightBracket",		// 0x1E
		  @"o",					// 0x1F
		  @"u",					// 0x20
		  @"leftBracket",		// 0x21
		  @"i",					// 0x22
		  @"p",					// 0x23
		  @"return",			// 0x24
		  @"l",					// 0x25
		  @"j",					// 0x26
		  @"quote",				// 0x27
		  @"k",					// 0x28
		  @"semicolon",			// 0x29
		  @"backslash",			// 0x2A
		  @"comma",				// 0x2B
		  @"slash",				// 0x2C
		  @"n",					// 0x2D
		  @"m",					// 0x2E
		  @"period",			// 0x2F
		  @"tab",				// 0x30
		  @"space",				// 0x31
		  @"grave",				// 0x32
		  @"delete",			// 0x33
		  JXKUndefinedKeyCode,	// 0x34
		  @"escape",			// 0x35
		  JXKUndefinedKeyCode,	// 0x36
		  @"command",			// 0x37
		  @"shift",				// 0x38
		  @"capsLock",			// 0x39
		  @"option",			// 0x3A
		  @"control",			// 0x3B
		  @"rightShift",		// 0x3C
		  @"rightOption",		// 0x3D
		  @"rightControl",		// 0x3E
		  @"function",			// 0x3F
		  @"f17",				// 0x40
		  @"keypadDecimal",		// 0x41
		  JXKUndefinedKeyCode,	// 0x42
		  @"keypadMultiply",	// 0x43
		  JXKUndefinedKeyCode,	// 0x44
		  @"keypadPlus",		// 0x45
		  JXKUndefinedKeyCode,	// 0x46
		  @"keypadClear",		// 0x47
		  @"volumeUp",			// 0x48
		  @"volumeDown",		// 0x49
		  @"mute",				// 0x4A
		  @"keypadDivide",		// 0x4B
		  @"keypadEnter",		// 0x4C
		  JXKUndefinedKeyCode,	// 0x4D
		  @"keypadMinus",		// 0x4E
		  @"f18",				// 0x4F
		  @"f19",				// 0x50
		  @"keypadEquals",		// 0x51
		  @"keypad0",			// 0x52
		  @"keypad1",			// 0x53
		  @"keypad2",			// 0x54
		  @"keypad3",			// 0x55
		  @"keypad4",			// 0x56
		  @"keypad5",			// 0x57
		  @"keypad6",			// 0x58
		  @"keypad7",			// 0x59
		  @"f20",				// 0x5A
		  @"keypad8",			// 0x5B
		  @"keypad9",			// 0x5C
		  @"jisYen",			// 0x5D
		  @"jisUnderscore",		// 0x5E
		  @"jisKeypadComma",	// 0x5F
		  @"f5",				// 0x60
		  @"f6",				// 0x61
		  @"f7",				// 0x62
		  @"f3",				// 0x63
		  @"f8",				// 0x64
		  @"f9",				// 0x65
		  @"jisEisu",			// 0x66
		  @"f11",				// 0x67
		  @"jisKana",			// 0x68
		  @"f13",				// 0x69
		  @"f16",				// 0x6A
		  @"f14",				// 0x6B
		  JXKUndefinedKeyCode,	// 0x6C
		  @"f10",				// 0x6D
		  JXKUndefinedKeyCode,	// 0x6E
		  @"f12",				// 0x6F
		  JXKUndefinedKeyCode,	// 0x70
		  @"f15",				// 0x71
		  @"help",				// 0x72
		  @"home",				// 0x73
		  @"pageUp",			// 0x74
		  @"forwardDelete",		// 0x75
		  @"f4",				// 0x76
		  @"end",				// 0x77
		  @"f2",				// 0x78
		  @"pageDown",			// 0x79
		  @"f1",				// 0x7A
		  @"leftArrow",			// 0x7B
		  @"rightArrow",		// 0x7C
		  @"downArrow",			// 0x7D
		  @"upArrow",			// 0x7E
		  //JXKUndefinedKeyCode,	// 0x7F
		  ];
	});
	
	return array;
}

NSArray * buttonDownPropertyNamesForKeyCodesArray() {
	static dispatch_once_t OnceToken;
	static NSArray *array = nil;
	
	dispatch_once(&OnceToken, ^{
		NSArray *namesForKeyCodes = namesForKeyCodesArray();
		NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:KeyCodeCount];
		
		for (JXKeyCode keyCode = 0; keyCode < KeyCodeCount; keyCode++) {
			NSString *keyName = namesForKeyCodes[keyCode];
			
			if (![keyName isEqualToString:JXKUndefinedKeyCode]) {
				NSString *buttonDownPropertyName =
				[keyName stringByAppendingString:@"ButtonDown"];
				
				[mutableArray addObject:buttonDownPropertyName];
			}
			else {
				[mutableArray addObject:[NSNull null]];
			}
		}
		
		//NSLog(@"%@", mutableArray);
		array = [mutableArray copy];
	});
	
	return array;
}

CFDictionaryRef propertyNames2KeyCodesOffsetBy1Dict() {
	static dispatch_once_t OnceToken;
	static CFDictionaryRef dict = nil;
	
	dispatch_once(&OnceToken, ^{
		NSArray *propertyNamesForKeyCodes = buttonDownPropertyNamesForKeyCodesArray();
		CFMutableDictionaryRef mutableDict =
		CFDictionaryCreateMutable(kCFAllocatorDefault,
								  KeyCodeCount,
								  &kCFTypeDictionaryKeyCallBacks,
								  NULL);
		// keys: NSString, values: raw key codes + 1
		
		CFIndex i = 0;
		for (NSString *propertyName in propertyNamesForKeyCodes) {
			CFDictionaryAddValue(mutableDict,
								 //Dictionary doesn’t allow 0 keys for obvious reasons.
								 (const void *)propertyName,
								 (const void *)(i + 1) // Offset by 1.
								 );
			
			i++;
		}
		
		//CFShow(mutableDict);
		dict = CFDictionaryCreateCopy(kCFAllocatorDefault, mutableDict);
		//CFShow(dict);
		CFRelease(mutableDict);
	});
	
	return dict;
}

- (void)willChangeValueForKeyCode:(JXKeyCode)keyCode
{
	NSArray *buttonDownPropertyNames = buttonDownPropertyNamesForKeyCodesArray();
	NSString *key = buttonDownPropertyNames[keyCode];
	[self willChangeValueForKey:key];
}

- (void)didChangeValueForKeyCode:(JXKeyCode)keyCode
{
	NSArray *buttonDownPropertyNames = buttonDownPropertyNamesForKeyCodesArray();
	NSString *key = buttonDownPropertyNames[keyCode];
	[self didChangeValueForKey:key];
}
#endif

@end
