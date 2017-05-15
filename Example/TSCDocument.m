//
//  TSCDocumentDummy.m
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 02.05.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#import "TSCDocument.h"

#import "JXJKLStateMachine.h"
#import "TSCAVPlayerRateConstants.h"


@interface TSCDocument ()

@property (nonatomic, readwrite, strong) AVPlayer *player;

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


- (IBAction)playForwardsAtNaturalRate:(id)sender;
{
	self.player.rate = TSCAVPlayerRateNaturalForward;
}

- (IBAction)playBackwardsAtNaturalRate:(id)sender;
{
	self.player.rate = TSCAVPlayerRateNaturalBackward;
}


- (IBAction)playForwardsAtHalfNaturalRate:(id)sender;
{
	self.player.rate = TSCAVPlayerRateHalfNaturalForward;
}

- (IBAction)playBackwardsAtHalfNaturalRate:(id)sender;
{
	self.player.rate = TSCAVPlayerRateHalfNaturalBackward;
}


NSTimeInterval dummyFrameLength = 0.1;

- (void)playOneFrameMovingForward:(BOOL)moveForward
{
	if (moveForward) {
		[self playForwardsAtNaturalRate:self];
	}
	else {
		[self playBackwardsAtNaturalRate:self];
	}
	
	[self performSelector:@selector(pausePlayback:)
			   withObject:self
			   afterDelay:dummyFrameLength];
}

- (IBAction)playForwardsOneFrame:(id)sender;
{
	[self playOneFrameMovingForward:YES];
}

- (IBAction)playBackwardsOneFrame:(id)sender;
{
	[self playOneFrameMovingForward:NO];
}


NSTimeInterval halfNaturalRateDelay = 0.5;

- (IBAction)playForwardsOneFrameAndStartHalfNaturalRateTimer:(id)sender;
{
	[self playForwardsOneFrame:self];
	
	[self performSelector:@selector(playForwardsAtHalfNaturalRate:)
			   withObject:sender
			   afterDelay:halfNaturalRateDelay];
}

- (IBAction)playBackwardsOneFrameAndStartHalfNaturalRateTimer:(id)sender;
{
	[self playBackwardsOneFrame:self];
	
	[self performSelector:@selector(playBackwardsAtHalfNaturalRate:)
			   withObject:sender
			   afterDelay:halfNaturalRateDelay];
}


- (IBAction)pausePlaybackAndCancelPlayForwardsAtHalfNaturalRateTimerIfRunning:(id)sender;
{
	[self pausePlayback:self];
	
	[NSRunLoop cancelPreviousPerformRequestsWithTarget:self
											  selector:@selector(playForwardsAtHalfNaturalRate:)
												object:sender];
}

- (IBAction)pausePlaybackAndCancelPlayBackwardsAtHalfNaturalRateTimerIfRunning:(id)sender;
{
	[self pausePlayback:self];
	
	[NSRunLoop cancelPreviousPerformRequestsWithTarget:self
											  selector:@selector(playBackwardsAtHalfNaturalRate:)
												object:sender];
}


- (IBAction)pausePlayback:(id)sender;
{
	if (self.player.rate != TSCAVPlayerRatePaused) {
		self.player.rate = TSCAVPlayerRatePaused;
	}
}


float quantizedPlaybackRateForRate(const float current) {
	const float absolute = fabsf(current);
	const float logarithm = log2f(absolute);
	const float logarithmRounded = roundf(logarithm);
	//const float result = powf(2.0f, logarithmRounded);
	const float quantizedRate = exp2f(logarithmRounded);
	
	return quantizedRate;
}

float steppedPlaybackRateForRate(const float current, bool stepForward) {
	const float quantizedRate = quantizedPlaybackRateForRate(current);
	
	const bool valueIsNegative = signbit(current);
	
	const float signedFactor = valueIsNegative ? -1.0f : 1.0f;
	const bool scaleUp =
	valueIsNegative ?
	(stepForward ? 0.5f : 2.0f) :
	(stepForward ? 2.0f : 0.5f);
	
	const float stepFactor = scaleUp ? 2.0f : 0.5f;
	
	const float newRate = signedFactor * quantizedRate * stepFactor;

	return newRate;
}

float nextPlaybackRateForInitialRate(const float initialRate) {
	const float newRate = steppedPlaybackRateForRate(initialRate, true);

	return newRate;
}

float previousPlaybackRateForInitialRate(const float initialRate) {
	const float newRate = steppedPlaybackRateForRate(initialRate, false);
	
	return newRate;
}

- (IBAction)playAtNextRateForCurrentRate:(id)sender;
{
	const float initialRate = self.player.rate;
	const float newRate = (initialRate < 2.0f) ? 2.0f : nextPlaybackRateForInitialRate(initialRate);
	
	self.player.rate = newRate;
}

- (IBAction)playAtPreviousRateForCurrentRate:(id)sender;
{
	const float initialRate = self.player.rate;
	const float newRate = (-2.0f < initialRate) ? -2.0f : previousPlaybackRateForInitialRate(initialRate);
	
	self.player.rate = newRate;
}

@end
