//
//  JXPowersOfTwoHelpers.h
//  Transcriptions
//
//  Created by Jan on 27.02.17.
//
//

#pragma once


typedef struct {
	const bool specialCases;
	const bool keepPowersOfTwo;
	const bool wantIntegralResult;
} PowerOfTwoParameters;

typedef enum {
	NextPowerOfTwoAwayFromZero,
	ClosestPowerOfTwoAwayFromZero,
	ClosestPowerOfTwoRoundingHalfWay,
	ClosestPowerOfTwoTowardsZero,
	NextPowerOfTwoTowardsZero
} PowerOfTwoType;

static inline bool isHalfWayCaseForRounding(float normalizedFraction) {
	const bool result = (((-1.0f < normalizedFraction) && (normalizedFraction <= -0.75f)) ||
						 ((0.75f <= normalizedFraction) && (normalizedFraction < 1.0f)));
	
	return result;
}

static inline bool isHalfWayCaseForAwayFromZero(float normalizedFraction) {
	const bool result = (((-0.75f <= normalizedFraction) && (normalizedFraction < -0.50f)) ||
						 ((0.50f < normalizedFraction) && (normalizedFraction <= 0.75f)));
	
	return result;
}

// Based on this:
// http://stackoverflow.com/questions/466204/rounding-up-to-nearest-power-of-2#466242
// http://stackoverflow.com/a/20820860/152827
static inline float powerOfTwoForValueTypeParameters(const float value, const PowerOfTwoType type, const PowerOfTwoParameters p) {
	int exponent;
	
	const float normalizedFraction = frexpf(value, &exponent);
	
	const bool isExactPowerOfTwo =
	((normalizedFraction == 0.5f) ||
	 (normalizedFraction == -0.5f));
	
	if (isExactPowerOfTwo &&
		p.keepPowersOfTwo) {
		return value;
	}
	
	if ((type == NextPowerOfTwoTowardsZero) &&
		isExactPowerOfTwo) {
		exponent -= 1;
	}
	
	if ((type == ClosestPowerOfTwoRoundingHalfWay) &&
		isHalfWayCaseForRounding(normalizedFraction)) {
		exponent += 1;
	}
	
	if ((type == ClosestPowerOfTwoAwayFromZero) &&
		isHalfWayCaseForAwayFromZero(normalizedFraction)) {
		exponent += 1;
	}
	
	if ((p.wantIntegralResult) &&
		(exponent < 1)) {
		exponent = 1;
	}
	
	if (type == NextPowerOfTwoAwayFromZero) {
		exponent += 1;
	}
	
	const bool valueIsNegative = signbit(value);
	const float signedFactor = valueIsNegative ? -0.5f : 0.5f;
	
	const float result = ldexpf(signedFactor, exponent);
	return result;
}

static inline float nextPowerOfTwoAwayFromZero(const float value, const PowerOfTwoParameters p) {
	return powerOfTwoForValueTypeParameters(value, NextPowerOfTwoAwayFromZero, p);
}

static inline float nextPowerOfTwoTowardsZero(const float value, const PowerOfTwoParameters p) {
	return powerOfTwoForValueTypeParameters(value, NextPowerOfTwoTowardsZero, p);
}


static inline float closestPowerOfRoundingHalfWay(const float value, const PowerOfTwoParameters p) {
	return powerOfTwoForValueTypeParameters(value, ClosestPowerOfTwoRoundingHalfWay, p);
}

static inline float closestPowerOfTwoAwayFromZero(const float value, const PowerOfTwoParameters p) {
	return powerOfTwoForValueTypeParameters(value, ClosestPowerOfTwoAwayFromZero, p);
}

static inline float closestPowerOfTwoTowardsZero(const float value, const PowerOfTwoParameters p) {
	return powerOfTwoForValueTypeParameters(value, ClosestPowerOfTwoTowardsZero, p);
}


static inline float nextPowerOfTwo(const float value, const PowerOfTwoParameters p) {
	if (p.specialCases &&
		(-0.5f <= value) && (value < 0.5f)) {
		return 0.5f;
	}
	
	const bool valueIsNegative = signbit(value);
	const float result =
	valueIsNegative ?
	nextPowerOfTwoTowardsZero(value, p) :
	nextPowerOfTwoAwayFromZero(value, p);
	
	return result;
}

static inline float closestPowerOfTwo(const float value, const PowerOfTwoParameters p) {
	if (p.specialCases) {
		if ((-0.5f < value) && (value < 0.0f)) {
			return -0.5f;
		}
		else if (value == 0.0f) {
			return 0.0f;
		}
		else if ((0.0f < value) && (value < 0.5f)) {
			return 0.5f;
		}
	}
	
	const float result =
	closestPowerOfRoundingHalfWay(value, p);
	
	return result;
}

static inline float previousPowerOfTwo(const float value, const PowerOfTwoParameters p) {
	if (p.specialCases &&
		(-0.5f < value) && (value <= 0.5f)) {
		return -0.5f;
	}
	
	const bool valueIsNegative = signbit(value);
	const float result =
	valueIsNegative ?
	nextPowerOfTwoAwayFromZero(value, p) :
	nextPowerOfTwoTowardsZero(value, p);
	
	return result;
}
