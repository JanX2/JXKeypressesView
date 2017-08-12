//
//  JXJKLStateForRate.h
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 11.05.17.
//
//

#pragma once

#include "JXPowersOfTwoHelpers.h"
#include "TSCAVPlayerRateConstants.h"

static inline JXJKLState stateForQuantizedRate(float rate) {
	JXJKLState state;
	
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

static inline JXJKLState stateForRate(float rate) {
	PowerOfTwoParameters parameters = (PowerOfTwoParameters){
		.specialCases = true,
		.keepPowersOfTwo = true,
		.wantIntegralResult = false,
	};
	
	const float quantizedRate = closestPowerOfTwo(rate, parameters);
	
	JXJKLState state = stateForQuantizedRate(quantizedRate);
	
	return state;
}

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
