//
//  TSCDocumentDummy.h
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 02.05.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AVPlayer.h"


@interface TSCDocument : NSObject


@property (nonatomic, readonly, strong) AVPlayer *player;


- (IBAction)playForwardsAtNaturalRate:(id)sender;
- (IBAction)playBackwardsAtNaturalRate:(id)sender;

- (IBAction)playForwardsAtHalfNaturalRate:(id)sender;
- (IBAction)playBackwardsAtHalfNaturalRate:(id)sender;

- (IBAction)playForwardsOneFrame:(id)sender;
- (IBAction)playBackwardsOneFrame:(id)sender;

- (IBAction)playForwardsOneFrameAndStartHalfNaturalRateTimer:(id)sender;
- (IBAction)playBackwardsOneFrameAndStartHalfNaturalRateTimer:(id)sender;
- (IBAction)pausePlaybackAndCancelPlayForwardsAtHalfNaturalRateTimerIfRunning:(id)sender;
- (IBAction)pausePlaybackAndCancelPlayBackwardsAtHalfNaturalRateTimerIfRunning:(id)sender;

- (IBAction)pausePlayback:(id)sender;

- (IBAction)playAtNextRateForCurrentRate:(id)sender;
- (IBAction)playAtPreviousRateForCurrentRate:(id)sender;

@end
