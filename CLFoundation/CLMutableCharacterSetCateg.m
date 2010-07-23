//  CLMutableCharacterSetCateg.m
//  PostalChess
//  Created by Ettore Pasquini on 7/22/10.
//  Copyright 2010 Cubelogic. All rights reserved.

#import "CLMutableCharacterSetCateg.h"

@implementation NSMutableCharacterSet (CLMutableCharacterSetCateg)

+ (NSMutableCharacterSet *)punctSpaces
{
    NSMutableCharacterSet *set;
    
    set = [NSMutableCharacterSet characterSetWithCharactersInString:@""];
    [set formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [set formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
    return set;
}

@end
