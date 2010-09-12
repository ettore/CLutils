/* $Id: cutils_carbon.c $ 
 * $Change: $ $DateTime: $ $Author: $ 

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

#include "cutils_carbon.h"
#include "cl_debug.h"

#ifdef __cplusplus
extern "C" {
#endif
    
// -----------------------------------------------------------------------------
OSStatus refr_timer(EventLoopTimerRef *     inOutTimer, 
                    EventLoopTimerProcPtr   inTimerProc,
                    EventTimerInterval      inFireDelay,
                    EventTimerInterval      inInterval, /* 0 is one-shot */
                    void *                  inOutUserData)
{
    OSStatus err = noErr;
    
    if (inOutTimer == NULL)
    {
        debug0msg0("inOutTimer == NULL");
        err = -1;
    }
    else if (*inOutTimer == NULL)
    {
        EventLoopTimerUPP upp = NewEventLoopTimerUPP(inTimerProc);
        err = InstallEventLoopTimer(GetMainEventLoop(), 
                                    inFireDelay, inInterval, 
                                    upp, inOutUserData, inOutTimer);
        debug0msg("created new timer, ret code=%ld", err);
    }
    else
    {
        err = SetEventLoopTimerNextFireTime(*inOutTimer, inInterval);
        debug0msg("SetEventLoopTimerNextFireTime, ret code=%ld", err);
    }
    
    return err;
}

// -----------------------------------------------------------------------------
UInt64 usecs_since_startup()
{
    UnsignedWide usecs = {0, 0};
    Microseconds(&usecs);
    return UnsignedWideToUInt64(usecs);
}

// -----------------------------------------------------------------------------
CFStringRef appsupport_path_Create(int inDomain)
{
    FSRef appSuppRef;
    
    // gets a reference to the user's Application Support folder
    FSFindFolder(inDomain, kApplicationSupportFolderType,
                 kCreateFolder, &appSuppRef);
    
    CFURLRef appSuppURL = CFURLCreateFromFSRef(NULL, &appSuppRef);
    CFStringRef s = CFURLCopyFileSystemPath(appSuppURL, kCFURLPOSIXPathStyle);
    
    // cleanup
    CFRelease(appSuppURL);
    
    return s;
}

// -----------------------------------------------------------------------------
int screen_coord_mousepos(Point *pt)
{
    MouseTrackingResult trackingRes;
    OSStatus err = TrackMouseLocation(NULL, pt, &trackingRes);
    return err;
}

// -----------------------------------------------------------------------------
long system_version()
{
	long sysVers;
	Gestalt(gestaltSystemVersion, &sysVers);
    return sysVers;
}


#ifdef __cplusplus
}
#endif
