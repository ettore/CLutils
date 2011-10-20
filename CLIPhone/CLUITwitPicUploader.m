/*
 Copyright (c) 2010, Cubelogic. All rights reserved.
 
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

#import <QuartzCore/QuartzCore.h>

#import "clcg_gfx.h"

#import "CLUITwitPicUploader.h"


@implementation CLUITwitPicUploader

-(int)postSnapshot:(UIView*)v title:(NSString*)t message:(NSString*)msg
{
  if (v == nil)
    return -1;
  
  UIImage *snapshot = clcg_do_snapshot(v, t);
  return [self postImage:snapshot message:msg];
}


-(int)postSnapshot:(UIView*)snapped message:(NSString*)msg
{
  // snapshot the view
  UIGraphicsBeginImageContext(snapped.frame.size);
  [snapped.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return [self postImage:screenshot message:msg];
}


//-(int)sendScreenshot
//{
//    http://iphone-dev-tips.alterplay.com/search/label/MFMailComposeViewController
//    // attaching screenshot
//    NSData *myData = UIImagePNGRepresentation(screenshot);
//    [controller addAttachmentData:myData mimeType:@"image/png" fileName:@"route"];
//    // showing mail view
//    [self presentModalViewController:controller animated:YES];
//    [controller release];
//}

-(int)postImage:(UIImage*)img message:(NSString*)msg
{
    NSData *imagedata = UIImagePNGRepresentation(img);
    return [self postImageData:imagedata message:msg];
}


@end
