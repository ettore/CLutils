//  CLFoundationUtilsTests.h
//  CLUtils
//  Created by Ettore Pasquini on 5/2/10.
//  Copyright 2010 Cubelogic. All rights reserved.
//
//  Application unit tests contain unit test code that must be injected into an 
//  application to run correctly.  Define USE_APPLICATION_UNIT_TEST to 0 if the 
//  unit test code is designed to be linked into an independent test executable.

#import <SenTestingKit/SenTestingKit.h>
#import <Foundation/Foundation.h>
//#import "application_headers" as required


@interface CLFoundationUtilsTests : SenTestCase {

}

#if USE_APPLICATION_UNIT_TEST
- (void) testAppDelegate;       // simple test on application
#else
- (void) testFormattedTimeLeft;
- (void)testFormattedTimeLeftTypicalCases;
#endif

@end
