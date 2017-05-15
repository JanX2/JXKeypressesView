//
//  JXKeypressesDefinitions.h
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 02.05.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#pragma once

#import <Carbon/Carbon.h> // for kVK_* names


typedef unsigned short JXKeyCode;

extern const JXKeyCode JXKeyCodeUndefined;


typedef enum  __attribute__ ((__packed__)) {
	KeyIsDown		= true,
	KeyIsUp			= false,
	KeyIsHandled	= true,
	KeyNotHandled	= false,
} KeysArrayType;

_Static_assert(sizeof(KeysArrayType) == 1, "We want the key state array to be compact. So its elements need to be small.");


typedef enum {
	E_JDown_From___ToJ__  = 0,    /* ⬇kVK_ANSI_J ▆▆▆ → ▃▆▆, */
	E_KUp_FromJK_ToJ__    = 1,    /* ⬆kVK_ANSI_K ▃▃▆ → ▃▆▆, */
	E_JDown_From_K_ToJK_  = 2,    /* ⬇kVK_ANSI_J ▆▃▆ → ▃▃▆, */
	E_JUp_FromJK_To_K_    = 3,    /* ⬆kVK_ANSI_J ▃▃▆ → ▆▃▆, */
	E_KDown               = 4,    /* ⬇kVK_ANSI_K ?▆? → ?▃?, */
  //E_KDown_From___To_K_  = 4,    /* ⬇kVK_ANSI_K ▆▆▆ → ▆▃▆, */
	E_LUp_From_KLTo_K_    = 5,    /* ⬆kVK_ANSI_L ▆▃▃ → ▆▃▆, */
	E_LDown_From_K_To_KL  = 6,    /* ⬇kVK_ANSI_L ▆▃▆ → ▆▃▃, */
	E_KUp_From_KLTo__L    = 7,    /* ⬆kVK_ANSI_K ▆▃▃ → ▆▆▃, */
	E_LDown_From___To__L  = 8,    /* ⬇kVK_ANSI_L ▆▆▆ → ▆▆▃, */
  //E_KDown_FromJ__ToJK_  = 9,
  //E_KDown_From__LTo_KL  = 10,
	E_Count               = 9,
	E_Invalid             = 10,
} JXEvent;

