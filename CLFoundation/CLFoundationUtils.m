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

BOOL cl_isvalid_email(CFStringRef str)
{
    if (str == nil)
        return NO;
    
    char *s = (char*)[(NSString*)str UTF8String];
    int i = 0, at_cnt = 0, is_letter = 0;
    int len = [(NSString*)str length];
    char c = '\0', prevc;
    NSString *illegal = [NSString stringWithUTF8String:",/:;<=>?[\\]^`"];
    NSCharacterSet *illeg;
    BOOL success = YES;
    BOOL got_name = NO, got_tld = NO;
    BOOL got_period = NO; // check period after @
    const NSRange notfound = NSMakeRange(NSNotFound, 0);
    
    illeg = [NSCharacterSet characterSetWithCharactersInString:illegal];
    NSRange r = [(NSString *)str rangeOfCharacterFromSet:illeg];
    if (r.length != notfound.length || r.location != notfound.location)
        return NO;
    
    debug0msg("len=%d s=[%s]", len,s);
    while (success && i < len)
    {
        prevc = c;
        c = s[i];
        is_letter = isalpha(c);
        
        if (c == '@')
            at_cnt++;
        
        if (at_cnt == 0 && is_letter)
            got_name = YES;
        
        if (got_name && c == '.' && at_cnt >= 1) 
            got_period = YES;
        
        if (got_name && got_period && at_cnt >= 1 && is_letter)
            got_tld = YES;
        
        //debug0msg("c=%c gotname=%d gotperiod=%d gottld=%d ",
        //          c, got_name, got_period, got_tld);
        // 0x2B = '+'    0x7A = 'z'
        if (c < 0x2B || c > 0x7A 
            || at_cnt > 1 
            || ((prevc == '.' || prevc == '@') && c == '@')
            || ((prevc == '.' || prevc == '@') && c == '.'))
            success = NO;
        
        i++;
    } 
    
    return (success && got_name && got_period && got_tld);
}

BOOL cl_isascii_str(CFStringRef str)
{
    if (str == nil)
        return NO;
    
    char *s = (char*)[(NSString*)str UTF8String];
    int i = -1;
    int len = CFStringGetLength(str);
    if (len == 0)
        return NO;
    
    while (++i < len)
        if (!isascii(s[i]) || s[i] == 0x7F) //7F is DELETE char
            return NO;
    
    return YES;
}

// percent-escape a URL string
CFStringRef percEscStr(CFStringRef str)
{
    CFStringRef s;
    CFStringRef escthis = CFSTR(":/?#[]@!$&’()*+,;'= ");
    s = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, str, NULL, 
                                                escthis, kCFStringEncodingUTF8);
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

