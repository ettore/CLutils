/*
 *  CLFoundationUtils.m
 *  Created by Ettore Pasquini on 8/3/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 */

#import "CLFoundationUtils.h"
#import <Foundation/Foundation.h>

Boolean isEmpty(NSString *s)
{
    return (s == nil || [s compare:@""] == NSOrderedSame);
}

NSString *formattedTimeLeft(NSInteger seconds)
{
    const int onemin  = 60;
    const int onehour = 3600;
    const int oneday  = 86400;
    NSString *s;
    
    int d = abs(seconds / oneday);
    int secs_after_days = abs(seconds % oneday);
    char *ds = (d == 1 ? "" : "s");
        
    int h = abs(secs_after_days / onehour);
    int secs_after_hours = abs(secs_after_days % onehour);
    
    int m = abs(secs_after_hours / onemin);
    int secs = abs(secs_after_hours % onemin);

    if (d > 0 && h > 0 && m > 0)
        s = [NSString stringWithFormat:@"%d day%s, %d h, %d m", d,ds,h,m];
    else if (d > 0 && h > 0 && m == 0)
        s = [NSString stringWithFormat:@"%d day%s, %d h", d,ds,h];
    else if (d > 0 && h == 0 && m > 0)
        s = [NSString stringWithFormat:@"%d day%s, %d m", d,ds,m];
    else if (d > 0 && h == 0 && m == 0)
        s = [NSString stringWithFormat:@"%d day%s", d,ds];
    else if (d == 0 && h > 0 && m > 0)
        s = [NSString stringWithFormat:@"%d h, %d m", h,m];
    else if (d == 0 && h > 0 && m == 0)
        s = [NSString stringWithFormat:@"%d hours", h];
    else if (d == 0 && h == 0 && m > 0 && secs > 0)
        s = [NSString stringWithFormat:@"%d m, %d s", m, secs];
    else if (d == 0 && h == 0 && m > 0 && secs == 0)
        s = [NSString stringWithFormat:@"%d minutes", m];
    else if (d == 0 && h == 0 && m == 0)
        s = [NSString stringWithFormat:@"%d seconds", secs];
    
    
    return s;
}

// used for archiving defaults as NSData
NSData* arc(id foo) 
{
	return [NSKeyedArchiver archivedDataWithRootObject:foo];
}

// unarchive NSData from defaults
id unarc(NSString* key)
{
	NSData* temp = [[NSUserDefaults standardUserDefaults] dataForKey:key];
	if (temp == nil)
        return nil;
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:temp];
}

