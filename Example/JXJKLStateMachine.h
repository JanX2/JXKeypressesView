//
//  JXJKLStateMachine.h
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 30.04.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "JXKeypressesDefinitions.h"


@interface JXJKLStateMachine : NSObject

- (instancetype)initWithTarget:(id)target;

- (void)processEvent:(JXEvent)event;

@end
