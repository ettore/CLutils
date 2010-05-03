/*  CLFoundationUtils.h
 *  PostalChess
 *  Created by Ettore Pasquini on 7/19/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 */

#ifndef CL_FOUNDATION_UTILS_H_
#define CL_FOUNDATION_UTILS_H_

#import <Foundation/Foundation.h>

typedef void (* CLFoundationCallback)(id info);
typedef void (* CLCollectLoginCallback)(NSString *uname, NSString *passwd);

#define CLLocalized(key) \
    [[NSBundle mainBundle] localizedStringForKey:(key) value:(key) table:nil]

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

#endif
