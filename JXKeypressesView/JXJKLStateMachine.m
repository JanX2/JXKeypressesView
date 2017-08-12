//
//  JXJKLStateMachine.m
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 30.04.17.
//
//

#import "JXJKLStateMachine.h"

#import "TSCDocument.h"

#import "JXJKLState.h"
#import "JXJKLStateForRate.h"


typedef void (*JXAction)(id, SEL, id);
static const JXAction nil_action = NULL;

typedef struct {
	JXJKLState nextState;
	JXAction actionToTrigger;
	SEL actionSelector;
	JXAction preAction;
	SEL preActionSelector;
} state_element_t;


@implementation JXJKLStateMachine {
	__weak id _target;
	
	state_element_t *_stateMatrix;
}


# pragma mark Object lifecycle

- (instancetype)initWithTarget:(id)target;
{
	self = [super init];
	
	if (self) {
		_target = target;
		
		_stateMatrix = buildStateMatrix(_target);
	}
	
	return self;
}

- (void)dealloc
{
	destroyStateMatrix(_stateMatrix);
}


state_element_t * buildStateMatrix(id target) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
	SEL back1x       = @selector(playBackwardsAtNaturalRate:);
	SEL backNx       = @selector(playAtPreviousRateForCurrentRate:);
	SEL playNx       = @selector(playAtNextRateForCurrentRate:);
	SEL play1x       = @selector(playForwardsAtNaturalRate:);
	SEL pauseP       = @selector(pausePlayback:);
	SEL back1f       = @selector(playBackwardsOneFrameAndStartHalfNaturalRateTimer:);
	SEL play1f       = @selector(playForwardsOneFrameAndStartHalfNaturalRateTimer:);
	SEL ct			 = @selector(cancelHalfNaturalRateTimerIfRunning:);
#pragma clang diagnostic pop

	typedef struct {
		JXJKLState nextState;
		SEL actionToTrigger;
		SEL preAction;
	} state_selector_pair_t;
	
	const size_t stateMatrixTableCount = 3;
	const size_t stateMatrixBackwardsSectionColumnCount = 3;
	const size_t stateMatrixPauseSectionColumnCount = 3;
	const size_t stateMatrixForwardsSectionColumnCount = 3;
	
	state_selector_pair_t stateMatrixBackwardsSection[S_Count][stateMatrixBackwardsSectionColumnCount] =
	{
		/*{ Index,               0,                         1,                         2,                    },*/
		/*{ State/Event Name,    E_JDown_From___ToJ__,      E_KUp_FromJK_ToJ__,        E_JDown_From_K_ToJK_, },*/
		{/* S_FastBackwards,  */ {S_FastBackwards, backNx}, {S_Backwards, back1x, ct}, {S_Pause, back1f},    },
		{/* S_Backwards,      */ {S_FastBackwards, backNx}, {S_Backwards, back1x, ct}, {S_Pause, back1f},    },
		{/* S_HalfBackwards,  */ {S_Backwards,     back1x}, {S_Backwards, back1x, ct}, {S_Pause, back1f},    },
		{/* S_Pause,          */ {S_Backwards,     back1x}, {S_Pause,     pauseP, ct}, {S_Pause, back1f},    },
		{/* S_HalfForward,    */ {S_Backwards,     back1x}, {S_Backwards, back1x, ct}, {S_Pause, back1f},    },
		{/* S_Forward,        */ {S_Backwards,     back1x}, {S_Backwards, back1x, ct}, {S_Pause, back1f},    },
		{/* S_FastForward,    */ {S_Backwards,     back1x}, {S_Backwards, back1x, ct}, {S_Pause, back1f},    },
	};
	
	state_selector_pair_t stateMatrixPauseSection[S_Count][stateMatrixPauseSectionColumnCount] =
	{
		/*{ Index,               3,                     4,                    5,                     },*/
		/*{ State/Event Name,    E_JUp_FromJK_To_K_,    E_KDown,              E_LUp_From_KLTo_K_,    },*/
		{/* S_FastBackwards,  */ {S_Pause, pauseP, ct}, {S_Pause,    pauseP}, {S_Pause, pauseP, ct}, },
		{/* S_Backwards,      */ {S_Pause, pauseP, ct}, {S_Pause,    pauseP}, {S_Pause, pauseP, ct}, },
		{/* S_HalfBackwards,  */ {S_Pause, pauseP, ct}, {S_Pause,    pauseP}, {S_Pause, pauseP, ct}, },
		{/* S_Pause,          */ {S_Pause, pauseP, ct}, {S_NoChange, nil},    {S_Pause, pauseP, ct}, },
		{/* S_HalfForward,    */ {S_Pause, pauseP, ct}, {S_Pause,    pauseP}, {S_Pause, pauseP, ct}, },
		{/* S_Forward,        */ {S_Pause, pauseP, ct}, {S_Pause,    pauseP}, {S_Pause, pauseP, ct}, },
		{/* S_FastForward,    */ {S_Pause, pauseP, ct}, {S_Pause,    pauseP}, {S_Pause, pauseP, ct}, },
	};
	
	state_selector_pair_t stateMatrixForwardsSection[S_Count][stateMatrixForwardsSectionColumnCount] =
	{
		/*{ Index,               6,                    7,                       8,                       },*/
		/*{ State/Event Name,    E_LDown_From_K_To_KL, E_KUp_From_KLTo__L,      E_LDown_From___To__L,    },*/
		{/* S_FastBackwards,  */ {S_Pause, play1f},    {S_Forward, play1x, ct}, {S_Forward,     play1x}, },
		{/* S_Backwards,      */ {S_Pause, play1f},    {S_Forward, play1x, ct}, {S_Forward,     play1x}, },
		{/* S_HalfBackwards,  */ {S_Pause, play1f},    {S_Forward, play1x, ct}, {S_Forward,     play1x}, },
		{/* S_Pause,          */ {S_Pause, play1f},    {S_Pause,   pauseP, ct}, {S_Forward,     play1x}, },
		{/* S_HalfForward,    */ {S_Pause, play1f},    {S_Forward, play1x, ct}, {S_Forward,     play1x}, },
		{/* S_Forward,        */ {S_Pause, play1f},    {S_Forward, play1x, ct}, {S_FastForward, playNx}, },
		{/* S_FastForward,    */ {S_Pause, play1f},    {S_Forward, play1x, ct}, {S_FastForward, playNx}, },
	};
	
	typedef struct {
		state_selector_pair_t *tableSection;
		size_t rowCount;
		size_t columnCount;
	} section_metadata_t;
	
	section_metadata_t stateMatrixSectionMetadata[stateMatrixTableCount] =
	{
		{(state_selector_pair_t *)&stateMatrixBackwardsSection,   S_Count,   stateMatrixBackwardsSectionColumnCount  },
		{(state_selector_pair_t *)&stateMatrixPauseSection,       S_Count,   stateMatrixPauseSectionColumnCount      },
		{(state_selector_pair_t *)&stateMatrixForwardsSection,    S_Count,   stateMatrixForwardsSectionColumnCount   },
	};
	
	size_t elementCount = 0;
	size_t columnCount = 0;
	size_t *column2TableMap = NULL;
	
	// Determine table geometry.
	{
		for (size_t table = 0; table < stateMatrixTableCount; table += 1) {
			section_metadata_t metadata = stateMatrixSectionMetadata[table];
			elementCount += metadata.rowCount * metadata.columnCount;
			
			// Build column2TableMap.
			const size_t assembledTableColumnIndex = columnCount;
			const size_t nextColumnIndex = assembledTableColumnIndex + metadata.columnCount;
			
			size_t newTableSize = nextColumnIndex * sizeof(size_t);

			if (column2TableMap == NULL) {
				column2TableMap = malloc(newTableSize);
			}
			else {
				column2TableMap = reallocf(column2TableMap, newTableSize);
			}
			
			for (size_t col = assembledTableColumnIndex; col < nextColumnIndex; col += 1) {
				column2TableMap[col] = table;
			}
			
			columnCount = nextColumnIndex;
		}
	}
	
	state_element_t *stateMatrix = calloc(elementCount, sizeof(state_element_t));

#define DUMP_TABLE	0
	
	// Build state matrix.
	{
		size_t row = 0;
		size_t col = 0;
		
		size_t colInTableSection = 0;
		
		for (size_t elementIndex = 0; elementIndex < elementCount; elementIndex += 1) {
			assert(row < S_Count);
			
			size_t tableForColumn = column2TableMap[col];

			section_metadata_t metadata = stateMatrixSectionMetadata[tableForColumn];
			state_selector_pair_t *tableSection = metadata.tableSection;
			state_selector_pair_t *tableRow = &(tableSection[row * metadata.columnCount]);
			state_selector_pair_t *tableElement = &(tableRow[colInTableSection]);
			
			//printf("%zu" "\t" "%zd" "\t" "%zd" "\t" "%zd\n", row, col, tableForColumn, colInTableSection);
			
			state_element_t *element = &(stateMatrix[elementIndex]);
			
			SEL actionSelector = tableElement->actionToTrigger;
			SEL preActionSelector = tableElement->preAction;
			
			element->nextState = tableElement->nextState;
			element->actionSelector = actionSelector;
			element->preActionSelector = preActionSelector;
			
			JXAction action = nil_action;
			if (actionSelector != nil) {
				if ([[target class] instancesRespondToSelector:actionSelector]) {
					action = (JXAction)[target methodForSelector:actionSelector];
				}
				else {
					@throw [NSException exceptionWithName:NSInternalInconsistencyException
												   reason:@"Unsupported action in state machine."
												 userInfo:nil];
				}
			}
			
			element->actionToTrigger = action;
			
			JXAction preAction = nil_action;
			if (preActionSelector != nil) {
				if ([[target class] instancesRespondToSelector:preActionSelector]) {
					preAction = (JXAction)[target methodForSelector:preActionSelector];
				}
				else {
					@throw [NSException exceptionWithName:NSInternalInconsistencyException
												   reason:@"Unsupported pre-action in state machine."
												 userInfo:nil];
				}
			}
			
			element->preAction = preAction;
			
#if DUMP_TABLE
			printf("%u"
				   "," "%s"
				   "," "%s",
				   element->nextState,
				   actionSelector ? [NSStringFromSelector(actionSelector) UTF8String] : "nil",
				   preActionSelector ? [NSStringFromSelector(preActionSelector) UTF8String] : "nil");
#endif

			colInTableSection += 1;
			if (colInTableSection >= metadata.columnCount) {
				colInTableSection = 0;
			}
			
			col += 1;
			
			if (col >= columnCount) {
				row += 1;
				col = 0;
				
#if DUMP_TABLE
				printf("\n");
#endif
			}
			else {
#if DUMP_TABLE
				printf("\t");
#endif
			}
		}
	}
	
	free(column2TableMap);
	
	return stateMatrix;
}

void destroyStateMatrix(state_element_t *stateMatrix) {
	free(stateMatrix);
}


bool isValidState(JXJKLState state) {
	_Static_assert(S_FastBackwards == 0, "");
	return ((S_FastBackwards <= state) && (state < S_Count));
}

bool isValidEvent(JXEvent event) {
	_Static_assert(E_JDown_From___ToJ__ == 0, "");
	return ((E_JDown_From___ToJ__ <= event) && (event < E_Count));
}


- (void)processEvent:(JXEvent)event;
{
	if (event == E_Invalid)  return;
	
	TSCDocument *document = _target;
	float rate = document.player.rate;
	JXJKLState state = stateForRate(rate);
	
	assert(isValidState(state));
	assert(isValidEvent(event));
	
	// Determine the state matrix element depending on the current state and the triggered event.
	size_t elementIndex = ((size_t)state * E_Count) + (size_t)event;
	state_element_t stateTransition = _stateMatrix[elementIndex];
	
	if (stateTransition.nextState == S_NoChange)  return;
	
	// Transition to the next state (set current state to the next state obtained from the matrix)…
	assert(isValidState(stateTransition.nextState));
	
	// … trigger the pre-action…
	if (stateTransition.preAction != nil_action) {
		stateTransition.preAction(_target, stateTransition.preActionSelector, self);
	}
	
	// … and trigger the appropriate action.
	if (stateTransition.actionToTrigger != nil_action) {
		stateTransition.actionToTrigger(_target, stateTransition.actionSelector, self);
	}
	
	//assert(stateForRate(document.player.rate) == stateTransition.nextState); // This will fail for time-limited or delayed states.
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
