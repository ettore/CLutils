//  CLFoundationUtilsTests.m
//  CLUtils
//  Created by Ettore Pasquini on 5/2/10.
//  Copyright 2010 Cubelogic. All rights reserved.

#import "CLFoundationUtilsTests.h"
#import "CLFoundationUtils.h"

@implementation CLFoundationUtilsTests

#if USE_APPLICATION_UNIT_TEST     
// all code under test is in the iPhone Application

- (void) testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           
// all code under test is part of the Logic Tests

- (void)testFormattedTimeLeft
{
    NSLog(@"---- testFormattedTimeLeft ----");
    
    PChessGame *g = [MainTests createGame:1];
    const int onesec  = 1;
    const int onemin  = 60;
    const int onehour = 3600;
    const int oneday  = 86400;
    const NSTimeInterval today = timestampSinceEpoch();
    NSString *fmt;
    
    fmt = formattedTimeLeft(
    STAssertEquals([fmt compare:@"1 day" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");
    
    g.whiteTimeLeft = oneday * 2;
    fmt = [g formattedWhiteTimeLeft];
    STAssertEquals([fmt compare:@"2 days" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");
    
    // ignore seconds if we have days worth of time
    g.whiteTimeLeft = oneday * 2 - onesec;
    fmt = [g formattedWhiteTimeLeft];
    STAssertEquals([fmt compare:@"2 days" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");
    
    // ignore minutes if we have days worth of time
    g.whiteTimeLeft = oneday * 2 - onemin;
    fmt = [g formattedWhiteTimeLeft];
    STAssertEquals([fmt compare:@"2 days" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");
    
    g.whiteTimeLeft = oneday * 2 - onehour;
    fmt = [g formattedWhiteTimeLeft];
    STAssertEquals([fmt compare:@"1 day, 23 h" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");
    
    
}



#endif


@end
