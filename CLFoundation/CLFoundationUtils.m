/*
 *  CLFoundationUtils.m
 *  Created by Ettore Pasquini on 8/3/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "cl_debug.h"

#import "CLFoundationUtils.h"
#import "CLMutableCharacterSetCateg.h"

// percent-escape a URL string
CFStringRef percEscStr(CFStringRef str)
{
    CFStringRef s;
    CFStringRef escaped = CFSTR(":/?#[]@!$&’()*+,;'= ");
    s = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, str, NULL, 
                                                escaped, kCFStringEncodingUTF8);
    [(NSString*)s autorelease];
    return s;
}

NSInteger data2int(CFDataRef data, unsigned size)
{
    NSString *s;
    char buf[size];
    memset(buf, 0, size);
    CFDataGetBytes(data, CFRangeMake(0,size), (UInt8*)buf);
    s = [NSString stringWithUTF8String:buf]; //(char*)[data bytes]];dont work
    debug0cocoa(@"CFData as string=[%@]", s);
    NSInteger val = [s integerValue];
    return val;
}

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

NSString *shortenedName(NSString *name, int max_len)
{
    int len = [name length];
    if (len <= max_len)
        return name;
    
    NSCharacterSet *charset = [NSMutableCharacterSet punctSpaces];
    NSString *trimmed = [name stringByTrimmingCharactersInSet:charset];
    if ([trimmed length] == 0)
        return [name substringToIndex:max_len];
    
    NSArray *pieces = [trimmed componentsSeparatedByCharactersInSet:charset];
    trimmed = [pieces objectAtIndex:0];
    
    // concede tolerance of 2 extra chars, if still longer, truncate
    len = [trimmed length];
    if (len > max_len + 2)
        return [trimmed substringToIndex:max_len];
    
    return trimmed;
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

