//
//  JXKeypressesView.h
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 03.03.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class TSCDocument;

@interface JXKeypressesView : NSView

@property (nonatomic, readonly) TSCDocument *document;

@end
