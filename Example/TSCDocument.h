//
//  TSCDocument.h
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 02.05.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AVPlayer.h"


@interface TSCDocument : NSObject


@property (nonatomic, readonly, strong) AVPlayer *player;


@property (nonatomic, readonly, assign) BOOL playingForwardsAtNaturalRate;
@property (nonatomic, readonly, assign) BOOL playingBackwardsAtNaturalRate;

@property (nonatomic, readonly, assign) BOOL playingForwardsAtHalfNaturalRate;
@property (nonatomic, readonly, assign) BOOL playingBackwardsAtHalfNaturalRate;

@property (nonatomic, readonly, assign) BOOL playingFastForwards;
@property (nonatomic, readonly, assign) BOOL playingFastBackwards;

@property (nonatomic, readonly, assign) BOOL playingIsPaused;


- (IBAction)playForwardsAtNaturalRate:(id)sender;
- (IBAction)playBackwardsAtNaturalRate:(id)sender;

- (IBAction)playForwardsAtHalfNaturalRate:(id)sender;
- (IBAction)playBackwardsAtHalfNaturalRate:(id)sender;
- (IBAction)playForwardsAtNaturalRateAndCancelHalfNaturalRateTimerIfRunning:(id)sender;
- (IBAction)playBackwardsAtNaturalRateAndCancelHalfNaturalRateTimerIfRunning:(id)sender;

- (IBAction)playForwardsOneFrame:(id)sender;
- (IBAction)playBackwardsOneFrame:(id)sender;

- (IBAction)playForwardsOneFrameAndStartHalfNaturalRateTimer:(id)sender;
- (IBAction)playBackwardsOneFrameAndStartHalfNaturalRateTimer:(id)sender;
- (IBAction)pausePlaybackAndCancelHalfNaturalRateTimerIfRunning:(id)sender;

- (IBAction)pausePlayback:(id)sender;

- (IBAction)playAtNextRateForCurrentRate:(id)sender;
- (IBAction)playAtPreviousRateForCurrentRate:(id)sender;

@end
