//
//  JXState.h
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 15.05.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#pragma once

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
	S_NoChange           = 9,
} JXState;

