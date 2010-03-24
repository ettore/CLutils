//  CLTwitPicUploader.h
//  Created by Ettore Pasquini on 3/9/10.
//  Copyright 2010 Cubelogic. All rights reserved.

#import <Foundation/Foundation.h>

// REFACTOR CLASS INTO IPHONE SUBCLASS
#import <UIKit/UIKit.h>

typedef void(*CLTwitPicUploaderCallback)(NSString *response);

@protocol CLTwitPicDelegate

- (void)twitPicDidSucceed:(NSString*)response;
- (void)twitPicDidFail:(NSString*)errmsg code:(NSInteger)errcode;

@end

@interface CLTwitPicUploader : NSObject 
{
    NSString *twitterUsername;
    NSString *twitterPassword;
    id<CLTwitPicDelegate> delegate;
}

@property(retain,nonatomic) NSString *twitterUsername;
@property(retain,nonatomic) NSString *twitterPassword;

-(id)initWithUsername:(NSString*)uname 
             password:(NSString*)passwd
             delegate:(id<CLTwitPicDelegate>)delg;

//-(id)initWithUsername:(NSString*)uname 
//             password:(NSString*)passwd
//      successCallback:(CLTwitPicUploaderCallback)fun
//      failureCallback:(CLTwitPicUploaderCallback)fail;

-(int)postSnapshot:(UIView*)view message:(NSString*)msg;
-(int)postImage:(UIImage*)img message:(NSString*)msg;
-(int)postImageData:(NSData*)imagedata message:(NSString*)msg;

@end
