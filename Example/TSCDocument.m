//
//  TSCDocument.m
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 02.05.17.
//
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
