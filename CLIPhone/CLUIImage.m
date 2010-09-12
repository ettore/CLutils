//  Created by Ettore Pasquini on 10/11/09.

/*
 Copyright (c) 2009, Cubelogic. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without 
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, 
 this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, 
 this list of conditions and the following disclaimer in the documentation 
 and/or other materials provided with the distribution.
 * Neither the name of Cubelogic nor the names of its contributors may be 
 used to endorse or promote products derived from this software without 
 specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE.
 */

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

//+(UIImage *)imageWithSize:(CGSize)new_size
//{
//    //XXX
//    //XXX this code is broken. do not use.
//    //XXX
//    
//    assert(0);
//    
//    UIImage *tmp = [[UIImage alloc] init];
//    CGImageRef resized_img;
//    
//    resized_img = CGImageCreateWithImageInRect([tmp CGImage], 
//                                               CGRectMake(0, 0, 
//                                                          new_size.width,
//                                                          new_size.height));
//    [tmp release];
//    
//    tmp = [UIImage imageWithCGImage:resized_img];
//    return tmp;
//}

@end
