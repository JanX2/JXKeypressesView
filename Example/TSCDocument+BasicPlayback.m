//
//  TSCDocument+BasicPlayback.m
//  Transcriptions
//
//  Created by Jan on 12.07.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#import "TSCDocument+BasicPlayback.h"

@implementation TSCDocument (BasicPlayback)

- (IBAction)playPauseToggle:(id)sender;
{
	if (self.player.rate == TSCAVPlayerRatePaused) {
		self.player.rate = TSCAVPlayerRateNaturalForward;
	}
	else {
		self.player.rate = TSCAVPlayerRatePaused;
	}
}

- (IBAction)rePlay:(id)sender;
{
}


@end
