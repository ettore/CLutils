/* 
 Copyright (c) 2010, Cubelogic. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without 
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, 
 this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, 
 this list of conditions and the following disclaimer in the documentation 
 and/or other materials provided with the distribution.
 * Neither the name of Cubelogic nor the names of its contributors may be 
 used to endorse or promote products derived from this software without 
 specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef clutils_cocoa_h_
#define clutils_cocoa_h_

#include <CoreFoundation/CoreFoundation.h>

#ifdef __cplusplus
extern "C" {
#endif
    
    // ---------------------------
    // init
    
    enum CocoaOp {
        kCLCocoaShutdown = 0,
        kCLCocoaStartup  = 1
    };
    
    void cocoa_setup(CocoaOp op);
    
    // ---------------------------
    // window update wrappers

    void        cocoa_force_refr();
    void        flush_main_window();
    WindowRef   cocoa_main_window();
    WindowRef   cocoa_key_window();
    void        cocoa_update_windows();
    
    // ---------------------------
    // keystroke wrappers
    
    void        post_keystroke_cocoa();
    
    // ---------------------------
    // BannerWindow wrappers
    
    /*" Wrapper for BannerWindow class. Returns a pointer to a BannerWindow object
     Clients gain ownership of the returned object. "*/
    void *      create_show_banner(CFStringRef inImagePath);
    
    /*" Wrapper for BannerWindow class. The input argument is a pointer to a 
     BannerWindow object. Clients from C should use this function to 
     properly release the BannerWindow object. "*/
    void        destroy_banner(void *inBannerWindow);
    
    // ---------------------------
    
    /* Executes the script contained in the input string `inScript'. 
     * @param outValue  If the AppleScript returns a value, this function will
     *      return that value. For simplicity, it is coerced into an int value.
     * @param inOutErrorInfo    Error info dictionary (will be filled out).
     * @returns 0 for no errors, -1 if an error occurred.  */
    int cocoa_exec_applescript(CFStringRef inScript, 
                               CFDictionaryRef *inOutErrorInfo, 
                               SInt32 *outValue);
    
#ifdef __cplusplus
}
#endif

#endif
