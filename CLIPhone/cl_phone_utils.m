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
