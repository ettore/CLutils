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
