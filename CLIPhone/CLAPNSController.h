//  CLAPNSController.h
//  PostalChess
//  Created by Ettore Pasquini on 5/22/10.
//  Copyright 2010 Cubelogic. All rights reserved.

#import <Foundation/Foundation.h>

/*
 
 Notes on deviceToken and association with a user
 
 user installs app
 user launches app: deviceToken is saved in prefs
 user registers: deviceToken is saved in Player table row
 user changes email: THIS IS NO LOGOUT, same userID, same deviceToken
 
 if you add the concept of login-logout, then deviceToken can't be really
 associated to a user, as multiple users can login on same device.
 
 */

@interface CLAPNSController : NSObject {
    BOOL isPushRegistered; //is it registered for push notifications or not
    NSData *deviceToken;   //comes from APNS once you register
    NSDictionary *options; //from application:didFinishLaunchingWithOptions:
}

@property(nonatomic) BOOL isPushRegistered;
@property(nonatomic,retain,readonly) NSData *deviceToken;
@property(nonatomic,retain) NSDictionary *options;

// register with APNS
-(void)registerWithOptions:(NSDictionary *)opt;

// Called by application:didRegisterForRemoteNotificationsWithDeviceToken:
// from the app delegate. We get the deviceToken here.
-(void)receivedDeviceToken:(NSData *)data;

// registration with APNS failed :(
-(void)registrationFailed:(NSError *)err;

-(void)sendDeviceTokenToBackend;

@end
