/* 
    filename: cutils_bsd.h 
    Copyright 2008 Cubelogic. All rights reserved.
*/

#ifndef cutils_bsd_h_
#define cutils_bsd_h_

#define kCutilsUnkownHost               -1000

/* -----------------------------------------------------------------------------
 *  Sprints in outBuf the IP address (xxx.xxx.xxx.xxx) given the computer 
 *  name.                                                                     */
int cutils_get_ip(const char *inComputerName, size_t inBufSize, char *outBuf);

/* -----------------------------------------------------------------------------
 *  Redirects stdin to `input_fname' and stdout/stderr to `log_fname'. 
 *  If `input_fname' is NULL, it redirects stdin to /dev/zero;
 *  if `log_fname' is NULL, it redirects stout/stderr to /dev/null.           */
void cutils_redirect_std(const char *input_fname, const char *log_fname);

#endif

