//  CLUITwitPicUploader.h
//  PostalChess
//  Created by Ettore Pasquini on 3/23/10.
//  Copyright 2010 Cubelogic. All rights reserved.

#import <UIKit/UIKit.h>

#import "CLTwitPicUploader.h"

@interface CLUITwitPicUploader : CLTwitPicUploader {

}

-(int)postSnapshot:(UIView*)view message:(NSString*)msg;
-(int)postImage:(UIImage*)img message:(NSString*)msg;

@end
