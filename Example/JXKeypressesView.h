//
//  JXKeypressesView.h
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 03.03.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JXKeypressesView : NSView

@property (nonatomic, readonly, assign) BOOL fastReverseActivated;
@property (nonatomic, readonly, assign) BOOL fastForwardActivated;

@end
