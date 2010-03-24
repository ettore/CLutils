//  CLStringCateg.h
//  PostalChess
//  Created by Ettore Pasquini on 2/13/10.
//  Copyright 2010 Cubelogic. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSString (CLStringCateg)

/** Trims whitespaces only. */
- (NSString *)trimws;

/** Trims whitespaces and new lines too. */
- (NSString *)trimwsnl;

@end
