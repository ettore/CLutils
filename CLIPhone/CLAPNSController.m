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
@synthesize hasSyncedDeviceToken;
@synthesize deviceToken;
@synthesize options;

-(id)init
{
    if ((self = [super init]))
    {
        isPushRegistered = NO;
        hasSyncedDeviceToken = NO;
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
    debug0cocoa(@"registered for push notifications, deviceToken=\n%@", 
                [data description]);

    [data retain];
    if (deviceToken)
    {
        [deviceToken release];
        deviceToken = nil;
    }
    
    deviceToken = data;
    isPushRegistered = YES;
}

-(NSString*)deviceTokenString
{
    if (deviceToken == nil)
        return nil;
    
    NSString *tokstr;
    
//    const unsigned *tokdata = (const unsigned *)deviceToken;
//	tokstr = [NSString stringWithFormat:
//            @"%08x%08x%08x%08x%08x%08x%08x%08x", 
//            ntohl(tokdata[0]), ntohl(tokdata[1]), ntohl(tokdata[2]), 
//            ntohl(tokdata[3]), ntohl(tokdata[4]), ntohl(tokdata[5]),
//            ntohl(tokdata[6]), ntohl(tokdata[7])];

    tokstr = [[[[deviceToken description] 
                stringByReplacingOccurrencesOfString:@"<" withString:@""] 
               stringByReplacingOccurrencesOfString:@">" withString:@""] 
              stringByReplacingOccurrencesOfString:@" " withString:@""];
	
    debug0cocoa(@"deviceTokenString: DEVTOK_NSDATA=%@  NEWTOK=%@", 
                deviceToken, tokstr);
    
    return tokstr;
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

-(NSInteger)badgeCount
{
    if (options == nil)
        return 0;
    
    NSDictionary *aps = [options objectForKey:@"aps"];
    if (aps == nil)
        return 0;
    
    if ([aps objectForKey:@"badge"])
        return [[aps objectForKey:@"badge"] integerValue];
    
    return 0;
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
