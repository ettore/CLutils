/*  CLFoundationUtils.h
 *  Created by Ettore Pasquini on 7/19/09.
 *  
 *  These utils expose a dependency with CF in their interface.

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

#ifndef CL_FOUNDATION_UTILS_H_
#define CL_FOUNDATION_UTILS_H_

#import <Foundation/Foundation.h>

typedef void (* CLFoundationCallback)(id info);
typedef void (* CLCollectLoginCallback)(NSString *uname, NSString *passwd);

#define CLLocalized(key) \
    [[NSBundle mainBundle] localizedStringForKey:(key) value:(key) table:nil]

BOOL cl_isvalid_email(CFStringRef s);

/**
 * @return YES if the string contains only ASCII characters (code < 0x7F)
 *         NO otherwise
 */
BOOL cl_isascii_str(CFStringRef s);

/**
 * Percent-escapes i.e. url-encodes a string.
 */
CFStringRef percEscStr(CFStringRef str);

/** Extracts a int from given CFData. */
NSInteger data2int(CFDataRef data, unsigned size);

Boolean isEmpty(NSString *s);

// used for defaults archiving
NSData* arc(id foo);

// de-archive object with 'key' from defaults
id unarc(NSString* key);

/**
 * Returns a string with the input time formatted in number of 
 * days, hours, minutes. Seconds are ignored. The return string contains 
 * abbreviations for hours, minutes.
 *
 * E.g.
 *      2 days, 23h, 58m
 * 
 * Possible to do:
 *      2 days, 23 hours, 58 minutes
 */
NSString *formattedTimeLeft(NSInteger seconds);

/**
 * Returns a shortened version of a given name, taking the first words that 
 * match the given length. E.g.
 *      shortenedName(@"Ettore Pasquini", 10) --> "Ettore"
 * If the first word is still too long, it will be returned truncated with a
 * tolerance of + 2 additional chars.
 */
NSString *shortenedName(NSString *name, int max_len);

#endif
