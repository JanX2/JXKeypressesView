//
//  TSCDocument+AdvancedPlayback.h
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 12.07.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#import "TSCDocument.h"

@interface TSCDocument (AdvancedPlayback)

- (IBAction)playForwardsAtNaturalRate:(id)sender;
- (IBAction)playBackwardsAtNaturalRate:(id)sender;

- (IBAction)playForwardsAtHalfNaturalRate:(id)sender;
- (IBAction)playBackwardsAtHalfNaturalRate:(id)sender;
- (IBAction)cancelHalfNaturalRateTimerIfRunning:(id)sender;

- (IBAction)playForwardsOneFrame:(id)sender;
- (IBAction)playBackwardsOneFrame:(id)sender;

- (IBAction)pausePlayback:(id)sender;

- (IBAction)playAtNextRateForCurrentRate:(id)sender;
- (IBAction)playAtPreviousRateForCurrentRate:(id)sender;

@end