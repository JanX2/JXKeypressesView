//
//  JXKeypressesDefinitions.h
//  Keyboard Keypresses Aggregation
//
//  Created by Jan on 02.05.17.
//
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
} JXKeyState;

_Static_assert(sizeof(JXKeyState) == 1, "We want the key state array to be compact. So its elements need to be small.");


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
