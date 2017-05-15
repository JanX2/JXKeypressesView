//
//  AVPlayer.m
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 09.05.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#import "AVPlayer.h"

#import "TSCAVPlayerRateConstants.h"


@implementation AVPlayer

- (instancetype)init
{
	self = [super init];
	
	if (self) {
		_rate = TSCAVPlayerRatePaused;
	}
	
	return self;
}

@end
