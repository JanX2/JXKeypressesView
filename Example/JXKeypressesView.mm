//
//  JXKeypressesView.m
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 03.03.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#import "JXKeypressesView.h"


@interface JXKeypressesView ()

@property (nonatomic, readwrite, assign) BOOL jButtonDown;
@property (nonatomic, readwrite, assign) BOOL kButtonDown;
@property (nonatomic, readwrite, assign) BOOL lButtonDown;

@property (nonatomic, readwrite, assign) BOOL fastReverseActivated;
@property (nonatomic, readwrite, assign) BOOL fastForwardActivated;

@end

@implementation JXKeypressesView

- (void)keyDown:(NSEvent *)theEvent
{
	NSUInteger flags = theEvent.modifierFlags & NSDeviceIndependentModifierFlagsMask;
	
	NSString *eventCharacters = theEvent.charactersIgnoringModifiers;
	
	BOOL didHandle = YES;
	
	if ((flags == 0) && // We currently only want events without modifiers.
		(eventCharacters.length >= 1)) {
		unichar keyChar = [eventCharacters characterAtIndex:0];
		
		switch (keyChar) {
			case 'j':
				self.jButtonDown = YES;
				break;
				
			//case ' ':
			case 'k':
				self.kButtonDown = YES;
				break;
				
			case 'l':
				self.lButtonDown = YES;
				break;
				
#if 0
			case 'i':
				// Set loop in-point.
				break;
				
			case 'o':
				// Set loop out-point.
				break;
#endif
				
			default:
				didHandle = NO;
				break;
		}
	}
	else {
		// Clear all keys?
		self.jButtonDown = NO;
		self.kButtonDown = NO;
		self.lButtonDown = NO;
	}
	
	if (didHandle == NO) {
		[super keyDown:theEvent];
	}
}

- (void)keyUp:(NSEvent *)theEvent
{
	NSUInteger flags = theEvent.modifierFlags & NSDeviceIndependentModifierFlagsMask;
	
	NSString *eventCharacters = theEvent.charactersIgnoringModifiers;
	
	BOOL didHandle = (flags == 0);
	
	if (eventCharacters.length >= 1) {
		unichar keyChar = [eventCharacters characterAtIndex:0];
		
		switch (keyChar) {
			case 'j':
				self.jButtonDown = NO;
				break;
				
				//case ' ':
			case 'k':
				self.kButtonDown = NO;
				break;
				
			case 'l':
				self.lButtonDown = NO;
				break;
				
#if 0
			case 'i':
				// Set loop in-point.
				break;
				
			case 'o':
				// Set loop out-point.
				break;
#endif
				
			default:
				//didHandle = NO;
				break;
		}
	}
	
	if (didHandle == NO) {
		[super keyUp:theEvent];
	}
}

@end
