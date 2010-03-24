//  CLUITwitPicUploader.m
//  PostalChess
//  Created by Ettore Pasquini on 3/23/10.
//  Copyright 2010 Cubelogic. All rights reserved.

#import <QuartzCore/QuartzCore.h>

#import "CLUITwitPicUploader.h"

@implementation CLUITwitPicUploader

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
