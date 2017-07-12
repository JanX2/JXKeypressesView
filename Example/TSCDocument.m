//
//  TSCDocument.m
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 02.05.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#import "TSCDocument.h"


@interface TSCDocument ()

@property (nonatomic, readwrite, strong) AVPlayer *player;
@property (nonatomic, readwrite, strong) NSTimer *halfNaturalRateDelayTimer;

@end


@implementation TSCDocument

- (instancetype)init
{
	self = [super init];
	
	if (self) {
		_player = [AVPlayer new];
	}
	
	return self;
}


# pragma mark Properties & KVO support

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
	if ([key hasPrefix:@"playing"]) {
		return [NSSet setWithObject:@"self.player.rate"];
	}
	else {
		return [super keyPathsForValuesAffectingValueForKey:key];
	}
}

- (BOOL)playingIsPaused
{
	return (self.player.rate == TSCAVPlayerRatePaused);
}

- (BOOL)playingForwardsAtNaturalRate
{
	return (self.player.rate == TSCAVPlayerRateNaturalForward);
}

- (BOOL)playingBackwardsAtNaturalRate
{
	return (self.player.rate == TSCAVPlayerRateNaturalBackward);
}

- (BOOL)playingForwardsAtHalfNaturalRate
{
	return (self.player.rate == TSCAVPlayerRateHalfNaturalForward);
}

- (BOOL)playingBackwardsAtHalfNaturalRate
{
	return (self.player.rate == TSCAVPlayerRateHalfNaturalBackward);
}

- (BOOL)playingFastForwards
{
	return (self.player.rate > TSCAVPlayerRateNaturalForward);
}

- (BOOL)playingFastBackwards
{
	return (self.player.rate < TSCAVPlayerRateNaturalBackward);
}

@end
