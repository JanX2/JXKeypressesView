//
//  TSCDocument.h
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 02.05.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AVPlayer.h"

#import "TSCAVPlayerRateConstants.h"


@interface TSCDocument : NSObject


@property (nonatomic, readonly, strong) AVPlayer *player;
@property (nonatomic, readonly, strong) NSTimer *halfNaturalRateDelayTimer;


@property (nonatomic, readonly, assign) BOOL playingForwardsAtNaturalRate;
@property (nonatomic, readonly, assign) BOOL playingBackwardsAtNaturalRate;

@property (nonatomic, readonly, assign) BOOL playingForwardsAtHalfNaturalRate;
@property (nonatomic, readonly, assign) BOOL playingBackwardsAtHalfNaturalRate;

@property (nonatomic, readonly, assign) BOOL playingFastForwards;
@property (nonatomic, readonly, assign) BOOL playingFastBackwards;

@property (nonatomic, readonly, assign) BOOL playingIsPaused;


@end
