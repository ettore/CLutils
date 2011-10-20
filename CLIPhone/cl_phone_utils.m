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

#import <UIKit/UIKit.h>

#include "cl_debug.h" 
#import "cl_phone_utils.h"
#import "CLiOSmacros.h"

void init_ios_logging(CFStringRef appname, CFStringRef logname)
{
  NSString *logpath;

#if TARGET_IPHONE_SIMULATOR == 0
  NSArray *p;
  NSString *docdir;
    
  if (logname) {
    p = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docdir = [p objectAtIndex:0];
    logpath = [docdir stringByAppendingPathComponent:(NSString*)logname];

    // redirect stderr (used by NSLog etc) to our logfile
    freopen([logpath cStringUsingEncoding:NSASCIIStringEncoding],"w+",stdout);
    freopen([logpath cStringUsingEncoding:NSASCIIStringEncoding],"w+",stderr);
  } else {
    logpath = @"";
  }
#else
  logpath = @"";
#endif
    
  // init cl_debug with our logfile
  cl_debug_init([(NSString*)appname UTF8String], [logpath UTF8String]);
}

void redirect_stderr(CFStringRef logname)
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *docdir = [paths objectAtIndex:0];
    NSString *logpath = [docdir stringByAppendingPathComponent:(NSString*)logname];
    freopen([logpath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

BOOL isIPad()
{
    if (RUNNING_IOS_3_2_OR_GREATER)
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            return YES;
    
    return NO;
}

void CLSupportSendEmail(CFStringRef subject, CFStringRef body)
{
    NSString *s;
    
    s = [NSString stringWithFormat:
         @"mailto:support@cubelogic.org?subject=%@ Bug&body=%@", 
         subject, body];
    s = [s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:s];
    
    [[UIApplication sharedApplication] openURL:url];
}


void debugViewFrame(char *label, UIView *a_view)
{
#ifdef CL_DEBUG_0
  CGRect f = [a_view frame];
#endif
  debug0msg("%s, O (%.2f,%.2f) W=%.2f H=%.2f", label,
            f.origin.x, f.origin.y, f.size.width, f.size.height);
}
