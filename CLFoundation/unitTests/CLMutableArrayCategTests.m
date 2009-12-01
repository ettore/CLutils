//  CLMutableArrayCategTests.m
//  CLUtils
//  Created by Ettore Pasquini on 11/30/09.
//  Copyright 2009 Cubelogic. All rights reserved.

#import <Foundation/Foundation.h>
#import "CLMutableArrayCategTests.h"
#import "CLMutableArrayCateg.h"

@implementation CLMutableArrayCategTests

//#if USE_APPLICATION_UNIT_TEST
//#else

- (void) testReplaceObjectWithObject
{
    NSString *nuovo = @"NUOVO";
    NSMutableArray *a0;
    
    a0 = [[NSMutableArray alloc] initWithCapacity:1];
    [a0 replaceObject:nil withObject:nuovo];
    STAssertEquals([a0 count], (NSUInteger)0, @"array should be empty");
    [a0 release];

    NSString *s1 = @"1";
    a0 = [[NSMutableArray alloc] initWithCapacity:1];
    STAssertEquals([a0 count], (NSUInteger)0, @"array should be empty");
    [a0 addObject:s1];
    [a0 replaceObject:s1 withObject:nuovo];
    STAssertEquals([a0 count], (NSUInteger)1, @"array should have 1 element");
    STAssertEquals([a0 objectAtIndex:0], nuovo, @"should have NUOVO at pos 0");
    [a0 replaceObject:@"NOT THERE" withObject:@"DIFFERENT"];
    STAssertEquals([a0 count], 1u, @"array should have 1 element");
    STAssertEquals([a0 objectAtIndex:0], nuovo, @"should have NUOVO at pos 0");
    [a0 release];
    
    a0 = [[NSMutableArray alloc] initWithCapacity:1];
    STAssertEquals([a0 count], (NSUInteger)0, @"array should be empty");
    [a0 addObject:@"11"];
    [a0 replaceObject:@"11" withObject:nuovo];
    STAssertEquals([a0 count], (NSUInteger)1, @"array should have 1 element");
    STAssertEquals([a0 objectAtIndex:0], nuovo, @"should have NUOVO at pos 0");
    [a0 replaceObject:@"NOT THERE" withObject:@"DIFFERENT"];
    STAssertEquals([a0 count], 1u, @"array should have 1 element");
    STAssertEquals([a0 objectAtIndex:0], nuovo, @"should have NUOVO at pos 0");
    [a0 release];

    a0 = [[NSMutableArray alloc] initWithCapacity:3];
    STAssertEquals([a0 count], (NSUInteger)0, @"array should be empty");
    [a0 addObject:s1];
    [a0 addObject:@"2"];
    [a0 addObject:@"3"];
    [a0 replaceObject:@"2" withObject:nuovo];
    STAssertEquals([a0 count], 3u, @"array should have 3 element");
    STAssertEquals([a0 objectAtIndex:1], nuovo, @"should have NUOVO at pos 1");
    [a0 replaceObject:@"3" withObject:nuovo];
    STAssertEquals([a0 count], 3u, @"array should have 3 element");
    STAssertEquals([a0 objectAtIndex:2], nuovo, @"should have NUOVO at pos 2");
    [a0 replaceObject:@"1" withObject:nuovo];
    STAssertEquals([a0 count], 3u, @"array should have 3 element");
    STAssertEquals([a0 objectAtIndex:0], nuovo, @"should have NUOVO at pos 0");
    
    // at this point we replaced all elements with NUOVO;
    // now let's try to replace a non-existing element
    [a0 replaceObject:@"NOT THERE" withObject:@"DIFFERENT"];
    STAssertEquals([a0 count], 3u, @"array should have 3 element");
    STAssertEquals([a0 objectAtIndex:0], nuovo, @"should have NUOVO at pos 0");
    STAssertEquals([a0 objectAtIndex:1], nuovo, @"should have NUOVO at pos 1");
    STAssertEquals([a0 objectAtIndex:2], nuovo, @"should have NUOVO at pos 2");
    [a0 release];
}

//#endif


@end
