//  CLArrayCateg.m
//  PostalChess
//  Created by Ettore Pasquini on 11/30/09.
//  Copyright 2009 Cubelogic. All rights reserved.

#import "CLMutableArrayCateg.h"

@implementation NSMutableArray (CLMutableArrayCateg)

- (void)replaceObject:(id)o1 withObject:(id)o2
{
    NSUInteger i = [self indexOfObject:o1];
    if (i != NSNotFound)
        [self replaceObjectAtIndex:i withObject:o2];
}

@end
