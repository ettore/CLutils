//  CLTwitPicUploader.m
//  Created by Ettore Pasquini on 3/9/10.
//  Copyright 2010 Cubelogic. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "CLTwitPicUploader.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "cl_debug.h"
#import "CLTwitPicResponseParser.h"
#import "CLTwitPicResponse.h"
#import "CLXMLParseError.h"
#import "cl_errors.h"

@implementation CLTwitPicUploader

@synthesize twitterUsername;
@synthesize twitterPassword;
//@synthesize successCallback;
//@synthesize failCallback;
//
//-(id)initWithUsername:(NSString*)uname 
//             password:(NSString*)passwd
//      successCallback:(CLTwitPicUploaderCallback)func
//      failureCallback:(CLTwitPicUploaderCallback)fail
//{
//    if ((self = [super init]))
//    {
//        twitterUsername = uname;
//        twitterPassword = passwd;
//        successCallback = func;
//        failCallback = fail;
//    }
//    
//    return self;
//}

-(id)initWithUsername:(NSString*)uname 
             password:(NSString*)passwd
             delegate:(id<CLTwitPicDelegate> )delg
{
    if ((self = [super init]))
    {
        twitterUsername = uname;
        twitterPassword = passwd;
        delegate = delg;
    }
    
    return self;
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

-(int)postImageData:(NSData*)imagedata message:(NSString*)msg
{
    NSURL *twitpicURL = [NSURL URLWithString:@"http://twitpic.com/api/uploadAndPost"];
    ASIFormDataRequest *req;
    
    req = [[[ASIFormDataRequest alloc] initWithURL:twitpicURL] autorelease];
    [req setData:imagedata forKey:@"media"];
    [req setPostValue:twitterUsername forKey:@"username"];
    [req setPostValue:twitterPassword forKey:@"password"];
    [req setPostValue:msg forKey:@"message"];
    [req setDelegate:self];
    [req setDidFinishSelector:@selector(requestSuccess:)];
    [req setDidFailSelector:@selector(requestFail:)];
    [req start];
    
    return 0;
}

- (void)requestSuccess:(ASIHTTPRequest *)req
{
    NSString *response_xml = [req responseString];
    debug0cocoa(@"HTTPSTATUS=%@\nRESPONSE=%@\n", 
                [req responseStatusMessage], response_xml);
    
    NSInteger code = 0;
    NSString *info = nil;
    
    if ([req responseStatusCode] != 200)
    {
        info = [req responseStatusMessage];
        code = CL_TWITPIC_HTTP_ERR;
    }
    else 
    {
        CLTwitPicResponseParser *parser = [[CLTwitPicResponseParser alloc] init];
        parser.wantedTag = @"rsp";
        id  parsed = [parser parseData:[req responseData]];
        debug0cocoa(@"parsed=%@", parsed);
        
        if ([parsed isKindOfClass:[NSArray class]] && [(NSArray*)parsed count] == 1)
        {
            // insert the new game the client views
            CLTwitPicResponse *rsp = [(NSArray *)parsed objectAtIndex:0];
            if ([rsp.status compare:@"ok" 
                            options:NSCaseInsensitiveSearch] != NSOrderedSame)
            {
                code = CL_TWITPIC_LOGIN_ERR;
            }
        }
        else
        {
            code = CL_TWITPIC_PARSE_ERR;
            if ([parsed isKindOfClass:[CLXMLParseError class]])
                info = [parsed info];
            else
                info = [[parser parserError] localizedDescription];
        }
        
        [parser release];
    }
    
    if (code)
        [delegate twitPicDidFail:info code:code];
    else 
        [delegate twitPicDidSucceed:response_xml];
}

- (void)requestFail:(ASIHTTPRequest *)req
{
    NSError *error = [req error];
    LOG_NS(@"ASIHTTPRequest error: %@", error);
    [delegate twitPicDidFail:[error description] code:CL_TWITPIC_API_ERR];
}

@end
