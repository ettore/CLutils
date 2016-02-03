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


/*******************************************************************************

 THIS FILE IS DEPRECATED

 THESE UTILITIES WILL BE EITHER REMOVED (FOR THEY ARE OBSOLETE)
 OR MOVED INTO MORE APPROPRIATE PLACES

 ******************************************************************************/


#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "clcg_bundle_utils.h"
#import "cl_debug.h"
#import "CLFoundationUtils.h"


void cl_set(id *obj, id val)
{
  if (obj && *obj != val) {
    [val retain];
    [*obj release];
    *obj = val;
  }
}


BOOL cl_isvalid_email(CFStringRef str)
{
  if (str == nil) {
    return NO;
  }

  char *s = (char*)[(NSString*)str UTF8String];
  int is_letter = 0;
  NSUInteger i = 0, at_cnt = 0;
  NSUInteger len = [(NSString*)str length];
  char c = '\0', prevc;
  NSString *illegal = [NSString stringWithUTF8String:",/:;<=>?[\\]^`"];
  NSCharacterSet *illeg;
  BOOL success = YES;
  BOOL got_name = NO, got_tld = NO;
  BOOL got_period = NO; // check period after @
  const NSRange notfound = NSMakeRange(NSNotFound, 0);

  illeg = [NSCharacterSet characterSetWithCharactersInString:illegal];
  NSRange r = [(NSString *)str rangeOfCharacterFromSet:illeg];
  if (r.length != notfound.length || r.location != notfound.location) {
    return NO;
  }

  while (success && i < len) {
    prevc = c;
    c = s[i];
    is_letter = isalpha(c);

    if (c == '@') {
      at_cnt++;
    }

    if (at_cnt == 0 && is_letter) {
      got_name = YES;
    }

    if (got_name && c == '.' && at_cnt >= 1) {
      got_period = YES;
    }

    if (got_name && got_period && at_cnt >= 1 && is_letter) {
      got_tld = YES;
    }

    // 0x2B = '+'    0x7A = 'z'
    if (c < 0x2B || c > 0x7A
        || at_cnt > 1
        || ((prevc == '.' || prevc == '@') && c == '@')
        || ((prevc == '.' || prevc == '@') && c == '.')) {
      success = NO;
    }

    i++;
  }

  return (success && got_name && got_period && got_tld);
}


BOOL cl_isascii_str(CFStringRef str)
{
  if (str == nil) {
    return NO;
  }

  char *s = (char*)[(NSString*)str UTF8String];
  int i = -1;
  CFIndex len = CFStringGetLength(str);
  if (len == 0) {
    return NO;
  }

  while (++i < len) {
    if (!isascii(s[i]) || s[i] == 0x7F) { //7F is DELETE char
      return NO;
    }
  }

  return YES;
}


//TODO-XXX buggy!
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


NSString *localizedDays(long num_days)
{
  return (num_days == 1 ? CLCG_LOC(@"day") : CLCG_LOC(@"days"));
}


NSString *formattedTimeLeft(NSInteger seconds)
{
  const long onemin  = 60;
  const long onehour = 3600;
  const long oneday  = 86400;
  NSString *s, *days;

  long d = ABS(seconds / oneday);
  days = localizedDays(d);
  long secs_after_days = ABS(seconds % oneday);

  long h = ABS(secs_after_days / onehour);
  long secs_after_hours = ABS(secs_after_days % onehour);

  long m = ABS(secs_after_hours / onemin);
  long secs = ABS(secs_after_hours % onemin);

  if (d > 0 && h > 0 && m > 0) {
    s = [NSString stringWithFormat:@"%ld %@, %ld h, %ld m", d, days, h, m];
  } else if (d > 0 && h > 0 && m == 0) {
    s = [NSString stringWithFormat:@"%ld %@, %ld h", d, days, h];
  } else if (d > 0 && h == 0 && m > 0) {
    s = [NSString stringWithFormat:@"%ld %@, %ld m", d, days, m];
  } else if (d > 0 && h == 0 && m == 0) {
    s = [NSString stringWithFormat:@"%ld %@", d, days];
  } else if (d == 0 && h > 0 && m > 0) {
    s = [NSString stringWithFormat:@"%ld h, %ld m", h, m];
  } else if (d == 0 && h > 0 && m == 0) {
    s = [NSString stringWithFormat:@"%ld %@", h, CLCG_LOC(@"hours")];
  } else if (d == 0 && h == 0 && m > 0 && secs > 0) {
    s = [NSString stringWithFormat:@"%ld m, %ld s", m, secs];
  } else if (d == 0 && h == 0 && m > 0 && secs == 0) {
    s = [NSString stringWithFormat:@"%ld %@", m, CLCG_LOC(@"minutes")];
  } else if (d == 0 && h == 0 && m == 0) {
    s = [NSString stringWithFormat:@"%ld %@", secs, CLCG_LOC(@"seconds")];
  } else {
    s = [NSString stringWithFormat:@"%ld %@", (long)seconds, CLCG_LOC(@"seconds")];
  }

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
  if (temp == nil) {
    return nil;
  }

  return [NSKeyedUnarchiver unarchiveObjectWithData:temp];
}

