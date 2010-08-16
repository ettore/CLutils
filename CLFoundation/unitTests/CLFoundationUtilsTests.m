//  CLFoundationUtilsTests.m
//  CLUtils
//  Created by Ettore Pasquini on 5/2/10.
//  Copyright 2010 Cubelogic. All rights reserved.

#import "CLFoundationUtilsTests.h"
#import "CLFoundationUtils.h"
#import "cl_gen_utils.h"
#import "cl_debug.h"

@implementation CLFoundationUtilsTests

#if USE_APPLICATION_UNIT_TEST     
// all code under test is in the iPhone Application

- (void) testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           
// all code under test is part of the Logic Tests

- (void)test_cl_isvalid_email
{
    NSLog(@"---- test_cl_isvalid_email ----");

    STAssertTrue(cl_isvalid_email((CFStringRef)@"e@cubelogic.org"), @"");
    STAssertTrue(cl_isvalid_email((CFStringRef)@"a@b.it"), @"");
    STAssertTrue(cl_isvalid_email((CFStringRef)@"ettore_p@cubelogic.org"), @"");
    STAssertTrue(cl_isvalid_email((CFStringRef)@"ep123@cubelogic.org"), @"");
    STAssertTrue(cl_isvalid_email((CFStringRef)@"ep-123@cubelogic.org"), @"");
    STAssertTrue(cl_isvalid_email((CFStringRef)@"ep+123@cubelogic.org"), @"");
    STAssertTrue(cl_isvalid_email((CFStringRef)@"e.p_1-2+3@cu-be.logic.org"), @"");
    
    STAssertFalse(cl_isvalid_email(nil), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@""), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"a"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"b@a."), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"@a.d"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"@a. "), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@" @a. "), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"  ettore_p@cubelogic.org"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"ettore_p@cubelogic.org  "), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"ep 123@cubelogic.org"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"ep123 @cubelogic.org"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"ep123@cubelogic .com"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"ep123!@cubelogic.org"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"ep$123@cubelogic.org"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"e^p123@cubelogic.org"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"ep123@cube%logic.com"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"ep123cube&logic.com"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"ep123@cubelogi*c.com"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"ep123@cubelogic().com"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"ep123@c=ubelogic.com"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"ep123?@cubelogic.org"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"ep123@cubelogic?.com"), @"");
    
    // invalid email, but valid characters
    STAssertFalse(cl_isvalid_email((CFStringRef)@"ep123@cubelogiccom"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"ep123@info@domecom"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"ep123cubelogiccom"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"ep123cubelogic..com"), @"");
    
    // period and @ combos
    STAssertFalse(cl_isvalid_email((CFStringRef)@"ep..123@cubelogiccom"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"mario..luigi@italia.it"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"ettore@cubelogic..com"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"mario.@italia.it"), @"");
    STAssertFalse(cl_isvalid_email((CFStringRef)@"mario@.italia.it"), @"");
}

- (void)test_cl_isascii_str
{
    NSLog(@"---- test_cl_isascii_str ----");
    CFStringRef s;
    char cs[16];
    
    s = (CFStringRef)[NSString stringWithUTF8String:"~!@#$()_+{}|\\abc"];
    STAssertTrue(cl_isascii_str(s), @"");
    s = (CFStringRef)[NSString stringWithUTF8String:"\""];
    STAssertTrue(cl_isascii_str(s), @"");

    s = (CFStringRef)[NSString stringWithUTF8String:""];
    STAssertFalse(cl_isascii_str(s), @"");
    s = (CFStringRef)[NSString stringWithUTF8String:"€"];
    STAssertFalse(cl_isascii_str(s), @"");
    s = (CFStringRef)[NSString stringWithUTF8String:"as bc€"];
    STAssertFalse(cl_isascii_str(s), @"");
    s = (CFStringRef)[NSString stringWithUTF8String:"€a"];
    STAssertFalse(cl_isascii_str(s), @"");
    
    memset(cs, 0, 16);
    cs[0] = 0x7F;
    s = (CFStringRef)[NSString stringWithUTF8String:cs];
    STAssertFalse(cl_isascii_str(s), @"");
    
    
}

- (void)testPercEscStr
{
    NSLog(@"---- testPercEscStr ----");
    CFStringRef s1 = CFSTR("':/?#[]@!$&();=+*, ");
    CFStringRef s2 = percEscStr(s1);
    debug0cocoa(@"percent-escaped string:%@", s2);
    STAssertTrue([(NSString *)s2 isEqualToString:
                  @"%27%3A%2F%3F%23%5B%5D%40%21%24%26%28%29%3B%3D%2B%2A%2C%20"], @"");
    
    s2 = percEscStr(CFSTR("’"));
    debug0cocoa(@"percent-escaped APOSTROPHE:%@", s2);
    STAssertTrue([(NSString *)s2 isEqualToString:@"%E2%80%99"], 
                 @"apostrophe escaped differently");
}

- (void)testFormattedTimeLeftTypicalCases
{
    NSLog(@"---- testFormattedTimeLeftTypicalCases ----");
    
    const int onemin  = 60;
    const int onehour = 3600;
    const int oneday  = 86400;
    NSString *s;

    s = formattedTimeLeft(30*oneday - 22*onehour - 30*onemin);
    debug0cocoa(@"formatted=%@", s);
    STAssertEquals([s compare:@"29 days, 1 h, 30 m" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");
    
    s = formattedTimeLeft(30*oneday - 22*onehour - 30*onemin - 1);
    debug0cocoa(@"formatted=%@", s);
    STAssertEquals([s compare:@"29 days, 1 h, 29 m" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");
    
    s = formattedTimeLeft(29*oneday + 10*onehour + 30*onemin);
    debug0cocoa(@"formatted=%@", s);
    STAssertEquals([s compare:@"29 days, 10 h, 30 m" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");
    
    s = formattedTimeLeft(29*oneday + 10*onehour + 30*onemin + 2);
    debug0cocoa(@"formatted=%@", s);
    STAssertEquals([s compare:@"29 days, 10 h, 30 m" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");

    // this one is debatable: one could argue that it should return a rounded
    // to closest int result (29 days, 10 h, 30 m) instead of brute truncation
    s = formattedTimeLeft(29*oneday + 10*onehour + 30*onemin - 2);
    debug0cocoa(@"formatted=%@", s);
    STAssertEquals([s compare:@"29 days, 10 h, 29 m" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");
}

- (void)testFormattedTimeLeft
{
    NSLog(@"---- testFormattedTimeLeft ----");
    
    const int onesec  = 1;
    const int onemin  = 60;
    const int onehour = 3600;
    const int oneday  = 86400;
    NSString *s;
    
    s = formattedTimeLeft(oneday);
    debug0cocoa(@"formatted=%@", s);
    STAssertEquals([s compare:@"1 day" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");
    
    s = formattedTimeLeft(oneday * 2);
    debug0cocoa(@"formatted=%@", s);
    STAssertEquals([s compare:@"2 days" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");
    
    // ignore seconds if we have days worth of time
    s = formattedTimeLeft(oneday - onesec);
    debug0cocoa(@"formatted=%@", s);
    STAssertEquals([s compare:@"23 h, 59 m" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");

    s = formattedTimeLeft(oneday * 2 - onesec);
    debug0cocoa(@"formatted=%@", s);
    STAssertEquals([s compare:@"1 day, 23 h, 59 m" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");

    s = formattedTimeLeft(oneday - onemin * 5);
    debug0cocoa(@"formatted=%@", s);
    STAssertEquals([s compare:@"23 h, 55 m" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");
    
    s = formattedTimeLeft(oneday * 50 - onemin * 5);
    debug0cocoa(@"formatted=%@", s);
    STAssertEquals([s compare:@"49 days, 23 h, 55 m" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");

    s = formattedTimeLeft(oneday - onehour);
    debug0cocoa(@"formatted=%@", s);
    STAssertEquals([s compare:@"23 hours" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");
    
    s = formattedTimeLeft(oneday * 2 - onehour);
    debug0cocoa(@"formatted=%@", s);
    STAssertEquals([s compare:@"1 day, 23 h" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");

    s = formattedTimeLeft(oneday - 23*onehour - 5*onemin);
    debug0cocoa(@"formatted=%@", s);
    STAssertEquals([s compare:@"55 minutes" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");
    
    s = formattedTimeLeft(2*oneday - 23*onehour - 5*onemin);
    debug0cocoa(@"formatted=%@", s);
    STAssertEquals([s compare:@"1 day, 55 m" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");

    s = formattedTimeLeft(onehour - 5*onemin - 5);
    debug0cocoa(@"formatted=%@", s);
    STAssertEquals([s compare:@"54 m, 55 s" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");
    
    s = formattedTimeLeft(5*onemin);
    debug0cocoa(@"formatted=%@", s);
    STAssertEquals([s compare:@"5 minutes" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");

    s = formattedTimeLeft(40);
    debug0cocoa(@"formatted=%@", s);
    STAssertEquals([s compare:@"40 seconds" options:NSCaseInsensitiveSearch], 
                   NSOrderedSame, @"wrongly formatted time left");
}



#endif


@end
