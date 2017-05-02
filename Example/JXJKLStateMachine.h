//
//  JXJKLStateMachine.h
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 30.04.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
	S_FastBackwards      = 0,	/* ◀︎◀︎ */
	S_Backwards          = 1,	/* ◀︎ */
	S_HalfBackwards      = 2,	/* ½◀︎ */
	S_Pause              = 3,	/* ❙❙ */
	S_HalfForward        = 4,	/* ▶︎½ */
	S_Forward            = 5,	/* ▶︎ */
	S_FastForward        = 6,	/* ▶︎▶︎ */
	S_Count              = 7,
	S_Invalid            = 8,
	S_None               = 9,
} state_t;

typedef enum {
	E_JDown_From___ToJ__  = 0,    /* ⬇kVK_ANSI_J ▆▆▆ → ▃▆▆, */
	E_KUp_FromJK_ToJ__    = 1,    /* ⬆kVK_ANSI_K ▃▃▆ → ▃▆▆, */
	E_JUp_FromJK_To_K_    = 2,    /* ⬆kVK_ANSI_J ▃▃▆ → ▆▃▆, */
	E_JDown_From_K_ToJK_  = 3,    /* ⬇kVK_ANSI_J ▆▃▆ → ▃▃▆, */
	E_KDown_From___To_K_  = 4,    /* ⬇kVK_ANSI_K ▆▆▆ → ▆▃▆, */
	E_LUp_From_KLTo_K_    = 5,    /* ⬆kVK_ANSI_L ▆▃▃ → ▆▃▆, */
	E_LDown_From_K_To_KL  = 6,    /* ⬇kVK_ANSI_L ▆▃▆ → ▆▃▃, */
	E_KUp_From_KLTo__L    = 7,    /* ⬆kVK_ANSI_K ▆▃▃ → ▆▆▃, */
	E_LDown_From___To__L  = 8,    /* ⬇kVK_ANSI_L ▆▆▆ → ▆▆▃, */
	E_Count               = 9,
	E_Invalid             = 10,
} event_t;


@interface JXJKLStateMachine : NSObject

- (instancetype)initWithTarget:(id)target;

- (void)processEvent:(event_t)event;

@end
