//
//  CLAPNSController.m
//  PostalChess
//
//  Created by Ettore Pasquini on 5/22/10.
//  Copyright 2010 Cubelogic. All rights reserved.
//

#import "CLAPNSController.h"
#import <UIKit/UIKit.h>
#import "cl_debug.h"

@implementation CLAPNSController

@synthesize isPushRegistered;
@synthesize deviceToken;
@synthesize options;

-(id)init
{
    if ((self = [super init]))
    {
        isPushRegistered = NO;
    }
    
    return self;
}

-(void)registerWithOptions:(NSDictionary*)opt
{
    UIApplication *app = [UIApplication sharedApplication];
    self.options = opt;
    [app registerForRemoteNotificationTypes: 
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)];
}

-(void)receivedDeviceToken:(NSData *)data
{
    debug0cocoa(@"registered for push notifications, token=\n%@", data);

    [data retain];
    if (deviceToken)
    {
        [deviceToken release];
        deviceToken = nil;
    }
    
    deviceToken = data;
    isPushRegistered = YES;
    [self sendDeviceTokenToBackend];
}

-(void)registrationFailed:(NSError *)err
{
    debug0cocoa(@"registration for push notifications failed: %@", 
                [err description]);
    if (deviceToken)
    {
        [deviceToken release];
        deviceToken = nil;
    }
    
    isPushRegistered = NO;
}

/*
The application should connect with its provider and pass it this token, encoded in binary format. By requesting the device token and passing it to the provider every time your application launches, you help to ensure that the provider has the *CURRENT TOKEN* for the device. If a user restores a backup to a device other than the one that the backup was created for (for example, the user migrates data to a new device), he or she must launch the application at least once for it to receive notifications again. If the user restores backup data to a new device or reinstalls the operating system, the device token changes. Moreover, never cache a device token and give that to your provider; always get the token from the system whenever you need it.
 */
-(void)sendDeviceTokenToBackend
{
    // send token with user id?
}

/*
 -(void)processReceivedNotifications
 {
 id notif = [opt objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
 if (notif)
 {
 //The payload itself is an NSDictionary object that contains the elements
 //of the notification—alert message, badge number, sound, and so on. 
 //NSString *item_name = [notif.userInfo objectForKey:MOVE_ITEM_KEY];
 
 app.applicationIconBadgeNumber = notif.applicationIconBadgeNumber-1;
 }
 }
 */

//- (void)application:(UIApplication *)app
//didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)token
//{
//    const void *token_bytes = [token bytes];
//    
//    self.isPushRegistered = YES;
//    
//    [self sendProviderDeviceToken:token_bytes]; // custom method
//}
//
//- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err 
//{
//    LOG_NS(@"Error registring for push notifications: %@", err);
//}


@end
