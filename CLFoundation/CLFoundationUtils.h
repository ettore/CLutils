/*  CLFoundationUtils.h
 *  PostalChess
 *  Created by Ettore Pasquini on 7/19/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 */

#import <Foundation/Foundation.h>

#define CLLocalizedString(key) \
    [[NSBundle mainBundle] localizedStringForKey:(key) value:(key) table:nil]

Boolean isEmpty(NSString *s);
