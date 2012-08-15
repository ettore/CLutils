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

#import "CLAPNSController.h"
#import "clcg_debug.h"

@interface CLAPNSController ()
@property(nonatomic,retain,readwrite) NSData *deviceToken;
@end

@implementation CLAPNSController

@synthesize isPushRegistered;
@synthesize hasSyncedDeviceToken;
@synthesize deviceToken;
@synthesize options;


-(id)init
{
  return [self initWithOptions:nil];
}


// designated initializer.
// @param opt the dictionary received by application:didFinishLaunchWithOptions:
-(id)initWithOptions:(NSDictionary*)opt
{
  if (!(self = [super init]))
    return nil;
  
  isPushRegistered = NO;
  hasSyncedDeviceToken = NO;
  if (opt) {
    NSDictionary *payld;
    
    payld = [opt objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [self setOptions:payld];
  }
  
  return self;
}


-(void)registerForAllNotifications
{
  CLCG_P(@"Registering for Push Notifications...");
  UIApplication *app = [UIApplication sharedApplication];
  [app registerForRemoteNotificationTypes: 
   (UIRemoteNotificationTypeBadge 
    | UIRemoteNotificationTypeAlert
    | UIRemoteNotificationTypeSound)];
}


-(void)receivedDeviceToken:(NSData *)data
{
  CLCG_P(@"registered for push notifications, deviceToken=\n%@", [data description]);
  self.deviceToken = data;
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
    
    return tokstr;
}


-(void)registrationFailed:(NSError *)err
{
  CLCG_P(@"registration for push notifications failed: %@", [err description]);

  self.deviceToken = nil;
  isPushRegistered = NO;
}


-(NSInteger)badgeCount
{
  if (options == nil)
    return 0;

  NSDictionary *aps = [options objectForKey:@"aps"];
  if (aps == nil)
    return 0;

  id badgeobj = [aps objectForKey:@"badge"];
  if (badgeobj)
    return [badgeobj integerValue];

  return 0;
}


@end
