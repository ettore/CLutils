/* $Id: cutils_carbon.h $ 
 * $Change: $ $DateTime: $ $Author: $ 
 * Created by Ettore Pasquini on 11/8/06. */

#ifndef cutils_carbon_h_
#define cutils_carbon_h_

#include <Carbon/Carbon.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum 
{
	kCLCheetah	= 0x1000,
	kCLPuma		= 0x1010,
	kCLJaguar	= 0x1020,
	kCLPanther	= 0x1030,
	kCLTiger	= 0x1040,
	kCLLeopard	= 0x1050,
} CLMacOSSystemVersion;
	
OSStatus refr_timer(EventLoopTimerRef *inOutTimer, 
                    EventLoopTimerProcPtr inTimerProc,
                    EventTimerInterval inFireDelay,
                    EventTimerInterval inInterval,
                    void *inOutUserData);
UInt64 usecs_since_startup();
CFStringRef appsupport_path_Create(int inDomain);

/** Returns mouse position in screen coordinates. */
int screen_coord_mousepos(Point *pt);

long system_version();

#ifdef __cplusplus
}
#endif

#endif
