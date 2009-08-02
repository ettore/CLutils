/*  CLFoundationUtils.h
 *  PostalChess
 *  Created by Ettore Pasquini on 7/19/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 */

#define CLLocalizedString(key) \
    [[NSBundle mainBundle] localizedStringForKey:(key) value:(key) table:nil]
