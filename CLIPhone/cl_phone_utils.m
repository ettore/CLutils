/*
 *  cl_phone_utils.m
 *  CLUtils
 *
 *  Created by Ettore Pasquini on 7/25/10.
 *  Copyright 2010 Cubelogic. All rights reserved.
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
    
    p = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docdir = [p objectAtIndex:0];
    logpath = [docdir stringByAppendingPathComponent:(NSString*)logname];
    
    // redirect stderr (used by NSLog etc) to our logfile
    freopen([logpath cStringUsingEncoding:NSASCIIStringEncoding],"w+",stderr);
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
    CGRect f = [a_view frame];
    debug0msg("%s, O (%.2f,%.2f) W=%.2f H=%.2f", label,
              f.origin.x, f.origin.y, f.size.width, f.size.height);
}
