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

- (void)halfNaturalRateDelayTimerFired:(NSTimer *)timer
{
	NSDictionary *userInfo = timer.userInfo;
	
	self.halfNaturalRateDelayTimer = nil;

	id sender = [userInfo objectForKey:@"Sender"];

	NSNumber *wantForwardNum = [userInfo objectForKey:@"WantForward"];
	BOOL wantForward = [wantForwardNum boolValue];
	
	if (wantForward) {
		[self playForwardsAtHalfNaturalRate:sender];
	}
	else {
		[self playBackwardsAtHalfNaturalRate:sender];
	}
}

- (void)startHalfNaturalRateTimerWithSender:(id)sender
						   directionForward:(BOOL)wantForward
{
	[self stopHalfNaturalRateTimer];
	
	NSDictionary *userInfo = @{
							   @"Sender": sender,
							   @"WantForward": @(wantForward),
							   };
	
	self.halfNaturalRateDelayTimer =
	[NSTimer timerWithTimeInterval:halfNaturalRateDelay
							target:self
						  selector:@selector(halfNaturalRateDelayTimerFired:)
						  userInfo:userInfo
						   repeats:NO];
	
	[[NSRunLoop currentRunLoop] addTimer:self.halfNaturalRateDelayTimer
								 forMode:NSRunLoopCommonModes];
}

- (void)stopHalfNaturalRateTimer
{
	if (self.halfNaturalRateDelayTimer != nil) {
		[self.halfNaturalRateDelayTimer invalidate];
		self.halfNaturalRateDelayTimer = nil;
	}
}


- (IBAction)playForwardsOneFrameAndStartHalfNaturalRateTimer:(id)sender;
{
	[self playForwardsOneFrame:self];
	
	[self startHalfNaturalRateTimerWithSender:sender
							 directionForward:YES];
}

- (IBAction)playBackwardsOneFrameAndStartHalfNaturalRateTimer:(id)sender;
{
	[self playBackwardsOneFrame:self];
	
	[self startHalfNaturalRateTimerWithSender:sender
							 directionForward:NO];
}


- (IBAction)pausePlaybackAndCancelHalfNaturalRateTimerIfRunning:(id)sender;
{
	[self stopHalfNaturalRateTimer];
	
	[self pausePlayback:self];
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
