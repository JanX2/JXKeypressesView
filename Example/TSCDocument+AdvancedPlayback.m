//
//  TSCDocument+AdvancedPlayback.m
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 12.07.17.
//
//

#import "TSCDocument+AdvancedPlayback.h"


@interface TSCDocument ()

@property (nonatomic, readwrite, strong) NSTimer *halfNaturalRateDelayTimer; // This needs to be redeclared `readwrite` within `TSCDocument`as well!

@end


@implementation TSCDocument (AdvancedPlayback)

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

- (IBAction)cancelHalfNaturalRateTimerIfRunning:(id)sender;
{
	[self stopHalfNaturalRateTimer];
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

/*
 Copyright 2017 Jan Weiß
 
 Some rights reserved: https://opensource.org/licenses/BSD-3-Clause
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in
    the documentation and/or other materials provided with the
    distribution.
 
 3. Neither the name of the copyright holder nor the names of any
    contributors may be used to endorse or promote products derived
    from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
