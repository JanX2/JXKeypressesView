//
//  AppDelegate.m
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 03.03.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#import "AppDelegate.h"

#import "TSCDocument.h"
#import "JXKeypressesView.h"


@interface AppDelegate () {
	IBOutlet TSCDocument *_document;
	IBOutlet JXKeypressesView *_keypressesView;
}

@property (weak) IBOutlet NSWindow *window;

@property (nonatomic, readonly) TSCDocument *document;
@property (nonatomic, readonly) JXKeypressesView *keypressesView;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[_window makeFirstResponder: _keypressesView];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

@end
