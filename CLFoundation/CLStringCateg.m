//  CLStringCateg.m
//  PostalChess
//  Created by Ettore Pasquini on 2/13/10.
//  Copyright 2010 Cubelogic. All rights reserved.

#import "CLStringCateg.h"

@implementation NSString (CLStringCateg)

- (NSString *)trimws
{
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)trimwsnl
{
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
