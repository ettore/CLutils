//  Copyright 2008 Cubelogic. All rights reserved.

#import <Foundation/Foundation.h>
#import "cl_gen_utils.h"

CLTimestamp
timestampSinceEpoch()
{
    // timeIntervalSinceReferenceDate returns seconds since 1/1/2001
    // NSTimeIntervalSince1970 = seconds from Epoch and 1/1/2001
    return [NSDate timeIntervalSinceReferenceDate] + NSTimeIntervalSince1970;
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
