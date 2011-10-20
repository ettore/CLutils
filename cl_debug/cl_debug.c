/*  cl_debug
    v1.1

    Copyright (c) 2003-2008, Cubelogic. All rights reserved.

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

#include "cl_debug.h"

#include <string.h>

#if defined(USING_COREFOUNDATION) && !defined(__cplusplus)
void LOG_CF(const char *cs, CFStringRef theStr) 
{
    int len = CFStringGetLength(theStr) + 1;
    char *buf = (char *)malloc(sizeof(char) * len);
    CFStringGetCString(theStr, buf, len, kCFStringEncodingMacRoman);
    LOG("%s{%s}", cs, buf);
    free(buf);
}
#endif

cl_debug_info gCLDebugStat;

void cl_debug_init(const char *product_name, const char *log_file_path)
{
    if (product_name == NULL)
        product_name = "";
    
    if (log_file_path == NULL)
        log_file_path = "";
    
    strncpy(gCLDebugStat.product_name, product_name, 256);
    strncpy(gCLDebugStat.logfile_path, log_file_path, 1024);

    /* this is just a sensible initialization that doesn't preclude the usage
       of the custom log file.  If clients actually provide a custom log file, 
       the log file initialization will be done at the actual time of logging.
       This will enable clients to change the log file if for some strange 
       reason they need to.  (Yes, sometimes they do.)  */
    gCLDebugStat.logfile = CL_DEBUG_DEFAULT_LOGFILE;
}
