//  untitled.m
//  CLIPhone
//  Created by Ettore Pasquini on 10/14/09.
//  Copyright 2009 Cubelogic. All rights reserved.

#import "CLUIImageTests.h"
#import "CLUIImage.h"

@implementation CLUIImageTests

#if USE_APPLICATION_UNIT_TEST // all code under test is in the iPhone Application

- (void) testAppDelegate {
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
}

#else            // all code under test must be linked into the Unit Test bundle
- (void) testCompiler {
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//- (void) testUIImageWithSize
//{
//    CGSize orig_size = {32,40};
//    
//    //XXX this creates an image with size 0
//    UIImage *img = [UIImage imageWithSize:orig_size];
//    
//    CGSize size = [img size];
//    STAssertEquals(size.width, orig_size.width, @"width of image incorrect");
//    STAssertEquals(size.height, orig_size.height, @"height of image incorrect");
//}

//- (void) testCGImageCreate
//{
//    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
//    
//    //XXX this creates a NULL image for some reason.
//    CGImageRef img = CGImageCreate(32, 10, 8, 32, 40, cs, kCGBitmapFloatComponents, NULL, NULL, FALSE, kCGRenderingIntentDefault);
//    CFRelease(cs);
//    STAssertNotNil(img, @"create CG image is null");
//}

// just a test to realize that [[UIImage alloc] init] creates an 
// image of width == height == 0
- (void) testCreateImageFromUIImage
{
    UIImage *img = [[UIImage alloc] init];
    CGImageRef cgimg = [img CGImage];
    size_t w = CGImageGetWidth(cgimg);
    NSLog(@"cgimg width=%f", w);// width is 0
    STAssertTrue((w == 0), @"UIImage alloc init created a non-0 image");
}

#endif
@end
