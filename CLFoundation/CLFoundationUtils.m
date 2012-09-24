/*
 *  Created by Ettore Pasquini on 8/3/09.
 
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

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "clcg_bundle_utils.h"
#import "cl_debug.h"

#import "CLFoundationUtils.h"
#import "CLMutableCharacterSetCateg.h"

void cl_set(id *obj, id val)
{
    if (obj && *obj != val)
    {
        [val retain];
        [*obj release];
        *obj = val;
    }
}

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

//XXX buggy!
NSInteger data2int(CFDataRef data)
{
    if (data == nil)
        return NSIntegerMin;
    
    NSString *s;
    char *buf;
    NSInteger val = NSIntegerMin;
    const CFIndex size = CFDataGetLength(data);
    
    buf = (char *)malloc(size + 1);
    memset(buf, 0, size);
    CFDataGetBytes(data, CFRangeMake(0,size), (UInt8*)buf);
    buf[size] = '\0';
    
    s = [NSString stringWithUTF8String:buf]; //(char*)[data bytes]];dont work
    debug0cocoa(@"CFData as string=[%@]", s);
    if (s) {
        unichar c = [s characterAtIndex:0];
        if ((c >= 48 && c <= 57) || c == '-' || c == '+')
            val = [s integerValue];
    }
    
    free(buf);
    return val;
}

Boolean isEmpty(NSString *s)
{
    return (s == nil || [s compare:@""] == NSOrderedSame);
}

CLTimestamp
timestampSinceEpoch()
{
    // timeIntervalSinceReferenceDate returns seconds since 1/1/2001
    // NSTimeIntervalSince1970 = seconds from Epoch and 1/1/2001
    return [NSDate timeIntervalSinceReferenceDate] + NSTimeIntervalSince1970;
}

NSString *localizedDays(int num_days)
{
  return (num_days == 1 ? CLCG_LOC(@"day") : CLCG_LOC(@"days"));
}

NSString *formattedTimeLeft(NSInteger seconds)
{
  const int onemin  = 60;
  const int onehour = 3600;
  const int oneday  = 86400;
  NSString *s, *days;
  
  int d = abs(seconds / oneday);
  days = localizedDays(d);
  int secs_after_days = abs(seconds % oneday);
    
  int h = abs(secs_after_days / onehour);
  int secs_after_hours = abs(secs_after_days % onehour);

  int m = abs(secs_after_hours / onemin);
  int secs = abs(secs_after_hours % onemin);

  if (d > 0 && h > 0 && m > 0)
    s = [NSString stringWithFormat:@"%d %@, %d h, %d m", d, days, h, m];
  else if (d > 0 && h > 0 && m == 0)
    s = [NSString stringWithFormat:@"%d %@, %d h", d, days, h];
  else if (d > 0 && h == 0 && m > 0)
    s = [NSString stringWithFormat:@"%d %@, %d m", d, days, m];
  else if (d > 0 && h == 0 && m == 0)
    s = [NSString stringWithFormat:@"%d %@", d, days];
  else if (d == 0 && h > 0 && m > 0)
    s = [NSString stringWithFormat:@"%d h, %d m", h, m];
  else if (d == 0 && h > 0 && m == 0)
    s = [NSString stringWithFormat:@"%d %@", h, CLCG_LOC(@"hours")];
  else if (d == 0 && h == 0 && m > 0 && secs > 0)
    s = [NSString stringWithFormat:@"%d m, %d s", m, secs];
  else if (d == 0 && h == 0 && m > 0 && secs == 0)
    s = [NSString stringWithFormat:@"%d %@", m, CLCG_LOC(@"minutes")];
  else if (d == 0 && h == 0 && m == 0)
    s = [NSString stringWithFormat:@"%d %@", secs, CLCG_LOC(@"seconds")];
  else
    s = [NSString stringWithFormat:@"%d %@", seconds, CLCG_LOC(@"seconds")];

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

