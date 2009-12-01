/*  tests_cutils_carbon.c
 *  cutils
 *  Created by cucchiaio on 11/12/06.
 *  Copyright 2006 __MyCompanyName__. All rights reserved.
 */

#include <unistd.h>
#include <CoreFoundation/CoreFoundation.h>
#include <Carbon/Carbon.h>

#include "cl_debug.h"
#include "cutils_carbon.h"
#include "tests_cutils_carbon.h"

/* -------------------------------------------------------------------------- */
/* cutils_test_refr_timer                                                     */

void cutils_test_refr_timercb(EventLoopTimerRef inTimer, void *udata)
{
#pragma unused(inTimer)
    int *fireTimes = (int *)udata;
    (*fireTimes)++;
    LOG("timer callback:: fireTimes=%d", *fireTimes); 
}

void killrl_timercb(EventLoopTimerRef inTimer, void *udata)
{
#pragma unused(inTimer, udata)
    LOG0("Quitting app event loop"); 
    QuitApplicationEventLoop();
}

void cutils_test_refr_timer()
{
    int                         i, fireTimes = 0;
    const int                   kNumRefr = 5;
    const EventTimerInterval    kRefrTime = 0.5; // keep this shorter than 1 sec
    EventLoopTimerRef           timer = NULL, rltimer = NULL;
    OSStatus                    err;
    EventLoopTimerUPP           upp;
    
    LOG0("---- cutils_test_refr_timer ---------------------------------------");
    
    // start timer with long fire delay
    refr_timer(&timer, &cutils_test_refr_timercb, 2, 0, &fireTimes);
    
    for (i = 0; i < kNumRefr; i++)
    {
        // refresh timer with shorter fire delay. This should just (1) override
        // the previous one-shot fire and (2) continuously prolong the 
        // firing time making the timer fire only once
        refr_timer(&timer, &cutils_test_refr_timercb, kRefrTime, 0, &fireTimes);
    }
    
    // execution flow never blocks, so given the long fire delays our 
    // fireTimes counter must still be 0
    LOG("cutils_test_refr_timer:: fireTimes=%d", fireTimes);
    assert(fireTimes == 0);
    
    // install another timer just to get out of the run loop (see below):
    // we'll make it fire way after the sum of all previous fire delays
    upp = NewEventLoopTimerUPP(killrl_timercb);
    err = InstallEventLoopTimer(GetMainEventLoop(), kNumRefr * kRefrTime * 5, 
                                0, upp, NULL, &rltimer);
    assert(err == 0);
    
    // we need to run the app event loop to actually let the `timer' work
    RunApplicationEventLoop();
    
    LOG("cutils_test_refr_timer:: fireTimes=%d", fireTimes); 
    assert(fireTimes == 1);
    
    err = RemoveEventLoopTimer(rltimer);
    assert(err == 0);
    err = RemoveEventLoopTimer(timer);
    assert(err == 0);
}

/* -------------------------------------------------------------------------- */
void cutils_test_appsupport_path_Create()
{
    LOG0("---- cutils_test_appsupport_path_Create --------------------------");
    
    CFStringRef appSuppLocal = appsupport_path_Create(kLocalDomain);
    CFShow(appSuppLocal);
    //LOG_CF("app support folder (local)", appSuppLocal);
    assert(CFStringCompare(appSuppLocal, 
                           CFSTR("/Library/Application Support"), 0) == 0);
    
}

/* -------------------------------------------------------------------------- */
void cutils_carbon_run_all_tests()
{
    //cutils_test_refr_timer();
    cutils_test_appsupport_path_Create();
    
    LOG("\n** %s: tests completed successfully. **\n", __FILE__);
}
