//
//  CLUIImage.m
//  CLIPhone
//
//  Created by Ettore Pasquini on 10/11/09.
//  Copyright 2009 Cubelogic. All rights reserved.
//

#include <assert.h>
#import "CLUIImage.h"

@implementation UIImage (CLUIImage)

+(UIImage *)imageFromImage:(UIImage *)img withSize:(CGSize)new_size
{
    CGImageRef orig_img, resized_img;
    
    orig_img = [img CGImage];
    resized_img = CGImageCreateWithImageInRect(orig_img, 
                                               CGRectMake(0, 0, 
                                                          new_size.width,
                                                          new_size.height));
    // clients should take care of releasing
    //[orig_img release];

    return [UIImage imageWithCGImage:resized_img];
}

+(UIImage *)imageWithSize:(CGSize)new_size
{
    //XXX
    //XXX this code is broken. do not use.
    //XXX
    
    assert(0);
    
    UIImage *tmp = [[UIImage alloc] init];
    CGImageRef resized_img;
    
    resized_img = CGImageCreateWithImageInRect([tmp CGImage], 
                                               CGRectMake(0, 0, 
                                                          new_size.width,
                                                          new_size.height));
    [tmp release];
    
    tmp = [UIImage imageWithCGImage:resized_img];
    return tmp;
}

@end