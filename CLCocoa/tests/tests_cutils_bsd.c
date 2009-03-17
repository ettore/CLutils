/*  tests_cutils_bsd.c
 *  cutils
 *  Created by cucchiaio on 11/12/06.
 *  Copyright 2006 __MyCompanyName__. All rights reserved.
 */

#include <string.h>
#include <unistd.h>
#include <Carbon/Carbon.h>

#include "cl_debug.h"
#include "cutils_bsd.h"
#include "tests_cutils_bsd.h"

/* -------------------------------------------------------------------------- */
void cutils_bsd_run_all_tests()
{
    cutils_test_get_ip();
    LOG("\n** %s: tests completed successfully. **\n", __FILE__);
}

/* -------------------------------------------------------------------------- */
void cutils_test_get_ip()
{
    LOG0("---- cutils_test_get_ip -------------------------------------------");
    
    #define bufSize     64
    const char *hostName1 = "cube16.local";
    const char *hostName2 = "192.1.24.127";
    char my_ip[bufSize];
    int err;
    
    memset(my_ip, 0, bufSize);
    err = cutils_get_ip(hostName1, bufSize, my_ip);
    LOG("input name=[%s] ip=[%s]", hostName1, my_ip);
    assert(err == 0);
    err = strncmp(my_ip, "192.168.1.2", bufSize);
    assert(err == 0);

    // if we feed it w/ an IP already, it should return the same IP
    memset(my_ip, 0, bufSize);
    err = cutils_get_ip(hostName2, bufSize, my_ip);
    LOG("input name=[%s] ip=[%s]", hostName2, my_ip);
    assert(err == 0);
    err = strncmp(my_ip, hostName2, bufSize);
    assert(err == 0);
}
