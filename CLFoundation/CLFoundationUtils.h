/*  CLFoundationUtils.h
 *  PostalChess
 *  Created by Ettore Pasquini on 7/19/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 */

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
