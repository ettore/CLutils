//  Created by Ettore Pasquini on 5/22/10.

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


@interface CLAPNSController : NSObject 
{
  BOOL isPushRegistered;
  BOOL hasSyncedDeviceToken;
  NSData *deviceToken;   //comes from APNS once you register
  NSDictionary *options; //comes from application:didFinishLaunchingWithOptions:
}

@property(nonatomic) BOOL isPushRegistered;
@property(nonatomic) BOOL hasSyncedDeviceToken;
@property(nonatomic,retain,readonly) NSData *deviceToken;
@property(nonatomic,retain) NSDictionary *options;

// `opt' is the dictionary received by application:didFinishLaunchWithOptions:
-(id)initWithOptions:(NSDictionary*)app_opt;

// register with APNS for sound, badge, alert notifications
-(void)registerForAllNotifications;

// Called by application:didRegisterForRemoteNotificationsWithDeviceToken:
// from the app delegate. We get the deviceToken here.
-(void)receivedDeviceToken:(NSData *)data;

// adjust state in case registration with APNS failed.
-(void)registrationFailed:(NSError *)err;

//TODO-XXX This appears to be wrong.
// returns badge count from current options dictionary
-(NSInteger)badgeCount;

// convert NSData to string
-(NSString*)deviceTokenString;

@end
