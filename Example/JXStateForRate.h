//
//  JXStateForRate.h
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 11.05.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#pragma once

#include "JXPowersOfTwoHelpers.h"
#include "TSCAVPlayerRateConstants.h"

static inline JXState stateForQuantizedRate(float rate) {
	JXState state;
	
	if (rate <= -2.0) {
		state = S_FastBackwards;
	}
	else if (rate == TSCAVPlayerRateNaturalBackward) {
		state = S_Backwards;
	}
	else if (rate == TSCAVPlayerRateHalfNaturalBackward) {
		state = S_HalfBackwards;
	}
	else if (rate == TSCAVPlayerRatePaused) {
		state = S_Pause;
	}
	else if (rate == TSCAVPlayerRateHalfNaturalForward) {
		state = S_HalfForward;
	}
	else if (rate == TSCAVPlayerRateNaturalForward) {
		state = S_Forward;
	}
	else if (2.0 <= rate) {
		state = S_FastForward;
	}
	else {
		assert(false);
	}
	
	return state;
}

static inline JXState stateForRate(float rate) {
	PowerOfTwoParameters parameters = (PowerOfTwoParameters){
		.specialCases = true,
		.keepPowersOfTwo = true,
		.wantIntegralResult = false,
	};
	
	const float quantizedRate = closestPowerOfTwo(rate, parameters);
	
	JXState state = stateForQuantizedRate(quantizedRate);
	
	return state;
}
