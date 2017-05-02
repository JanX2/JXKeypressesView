//
//  JXKeypressesDefinitions.h
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 02.05.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#pragma once

#import <Carbon/Carbon.h> // for kVK_* names


typedef unsigned short KeyCodeType;

typedef bool KeysArrayType;

#if 1

#define KeyIsDown	true
#define KeyIsUp		false

#define KeyIsHandled	true
#define KeyNotHandled	false

#elif

extern const KeysArrayType KeyIsDown;
extern const KeysArrayType KeyIsUp;

extern const KeysArrayType KeyIsHandled;
extern const KeysArrayType KeyNotHandled;

#endif


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

