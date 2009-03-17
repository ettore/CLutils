/* $Id: cutils_carbon.c $ 
 * $Change: $ $DateTime: $ $Author: $ 
 * Created by Ettore Pasquini on 11/8/06. */

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
