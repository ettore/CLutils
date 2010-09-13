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

#import <Cocoa/Cocoa.h>

#include "cl_cocoa_cwrap.h"
#include "cl_debug.h"

// -----------------------------------------------------------------------------
void cocoa_setup(CocoaOp op)
{
    static NSAutoreleasePool *pool = NULL;
    
    if (op == kCLCocoaStartup && pool == NULL)
    {
        pool = [[NSAutoreleasePool alloc] init];
        NSApplicationLoad();
    } 
    else if (op == kCLCocoaShutdown && pool)
    {
        [pool release];
    }
}

// -----------------------------------------------------------------------------
void cocoa_force_refr()
{
    flush_main_window();
}

// -----------------------------------------------------------------------------
WindowRef cocoa_main_window()
{
    return [[NSApp mainWindow] windowRef];
}

// -----------------------------------------------------------------------------
WindowRef cocoa_key_window()
{
    return [[NSApp keyWindow] windowRef];
}

// -----------------------------------------------------------------------------
void cocoa_update_windows()
{
    [NSApp setWindowsNeedUpdate:YES];
}

// -----------------------------------------------------------------------------
void flush_main_window()
{
    NSWindow *mainWindow = [NSApp mainWindow];
    debug0cocoa(@"mainWin%#x: %@", mainWindow, [mainWindow title]);
    
    if ([mainWindow isFlushWindowDisabled])
        [mainWindow enableFlushWindow];
    
    [mainWindow flushWindow];
    [mainWindow update];
    [NSApp setWindowsNeedUpdate:YES];
    [NSApp updateWindows];
}

// -----------------------------------------------------------------------------
void cocoa_post_keystroke()
{
    debug_enter("post_keystroke_cocoa");
    NSPoint pt = {10.0, 10.0};
    UnsignedWide uwsecs1, uwsecs2;
    NSWindow *theWindow = [NSApp mainWindow];
    int winNum = [theWindow windowNumber];
    NSGraphicsContext *graphCtx = [NSGraphicsContext currentContext];
    NSString *keystroke = @"x";
        
    Microseconds(&uwsecs1);
    UInt64 usecs1 = UnsignedWideToUInt64(uwsecs1);
    NSTimeInterval timeSinceSysStartup = usecs1 / (double)1000000;
    NSEvent *ev = [NSEvent keyEventWithType:NSKeyDown
                                   location:pt
                              modifierFlags:NSAlternateKeyMask
                                  timestamp:timeSinceSysStartup 
                               windowNumber:winNum
                                    context:graphCtx
                                 characters:keystroke
                charactersIgnoringModifiers:keystroke
                                  isARepeat:NO
                                    keyCode:7];
    [theWindow postEvent:ev atStart:YES];
    
    Microseconds(&uwsecs2);
    UInt64 usecs2 = UnsignedWideToUInt64(uwsecs2);
    NSTimeInterval timeSinceSysStartup = usecs2 / (double)1000000;
    NSEvent *ev = [NSEvent keyEventWithType:NSKeyUp
                                   location:pt
                              modifierFlags:NSAlternateKeyMask
                                  timestamp:timeSinceSysStartup 
                               windowNumber:winNum
                                    context:graphCtx
                                 characters:keystroke
                charactersIgnoringModifiers:keystroke
                                  isARepeat:NO
                                    keyCode:7];
    [theWindow postEvent:ev atStart:YES];

    debug_exit("post_keystroke_cocoa");
}

// -----------------------------------------------------------------------------
int cocoa_exec_applescript(CFStringRef inSrc, 
                           CFDictionaryRef *inOutErrorDict,
                           SInt32 *outValue)
{
    // if not using the CocoaSetup routine, wrap every function with its own
    // autorelease pool
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSAppleScript *as = [[NSAppleScript alloc] initWithSource:(NSString *)inSrc];
    NSDictionary *nsDict;
    if (inOutErrorDict != NULL)
        nsDict = (NSDictionary *)*inOutErrorDict;
    
    NSAppleEventDescriptor *descr = [as executeAndReturnError: &nsDict];
    int err = 0;
    if (descr == nil)
    {
        NSLog(@"NSAppleScriptErrorMessage: %@; NSAppleScriptErrorAppName: %@", 
              [nsDict valueForKey: NSAppleScriptErrorMessage],
              [nsDict valueForKey: NSAppleScriptErrorAppName]);
        err = -1;
    }
    else if (outValue)
    {
        *outValue = [descr int32Value];
    }
    
    // cleanup
    [as release];
    
    // if not using the CocoaSetup routine, wrap every function with its own
    // autorelease pool
    //[pool release];
    
    return err;
}
