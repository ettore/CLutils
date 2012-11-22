/*
Created by Ettore Pasquini on 3/9/10.

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

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#import "clcg_macros.h"

#import "CLTwitPicUploader.h"
#import "cl_debug.h"
#import "CLTwitPicResponseParser.h"
#import "CLTwitPicResponse.h"
#import "CLXMLParseError.h"
#import "cl_errors.h"

@implementation CLTwitPicUploader

@synthesize twitterUsername;
@synthesize twitterPassword;


-(void)dealloc
{
  delegate = nil;
  [mReq clearDelegatesAndCancel];
  CLCG_REL(mReq);
  CLCG_REL(twitterUsername);
  CLCG_REL(twitterPassword);
  [super dealloc];
}


-(id)initWithUsername:(NSString*)uname 
             password:(NSString*)passwd
             delegate:(id<CLTwitPicDelegate> )delg
{
  if ((self = [super init])) {
    twitterUsername = [uname copy];
    twitterPassword = [passwd copy];
    delegate = delg;
  }
  
  return self;
}


-(int)postImageData:(NSData*)imagedata message:(NSString*)msg
{
  NSURL *twitpicURL = [NSURL URLWithString:@"http://twitpic.com/api/uploadAndPost"];
  
  [mReq clearDelegatesAndCancel];
  [mReq release];
  mReq = [[ASIFormDataRequest alloc] initWithURL:twitpicURL];
  [mReq setData:imagedata forKey:@"media"];
  [mReq setPostValue:twitterUsername forKey:@"username"];
  [mReq setPostValue:twitterPassword forKey:@"password"];
  [mReq setPostValue:msg forKey:@"message"];
  [mReq setDelegate:self];
  [mReq setDidFinishSelector:@selector(requestSuccess:)];
  [mReq setDidFailSelector:@selector(requestFail:)];
  [mReq start];
  
  return 0;
}


- (void)requestSuccess:(ASIHTTPRequest *)req
{
  NSString *response_xml = [req responseString];
  NSInteger code = 0;
  NSString *info = nil;
  
  if ([req responseStatusCode] != 200) {
    info = [req responseStatusMessage];
    code = CL_TWITPIC_HTTP_ERR;
  } else {
    CLTwitPicResponseParser *parser = [[CLTwitPicResponseParser alloc] init];
    parser.wantedTag = @"rsp";
    id  parsed = [parser parseData:[req responseData]];
    
    if ([parsed isKindOfClass:[NSArray class]] && [(NSArray*)parsed count] == 1) {
        // insert the new game the client views
        CLTwitPicResponse *rsp = [(NSArray *)parsed objectAtIndex:0];
        if ([rsp.status compare:@"ok" 
                        options:NSCaseInsensitiveSearch] != NSOrderedSame)
        {
            code = CL_TWITPIC_LOGIN_ERR;
        }
    } else {
      code = CL_TWITPIC_PARSE_ERR;
      if ([parsed isKindOfClass:[CLXMLParseError class]])
        info = [parsed info];
      else
        info = [[parser parserError] localizedDescription];
    }
    
    [parser release];
  }
  
  if (code)
    [delegate twitPicDidFail:self msg:info code:code];
  else 
    [delegate twitPicDidSucceed:self response:response_xml];
  
  CLCG_REL(req);
}


- (void)requestFail:(ASIHTTPRequest *)req
{
  NSError *error = [req error];
  LOG_NS(@"ASIHTTPRequest error: %@", error);
  [delegate twitPicDidFail:self msg:[error description] code:CL_TWITPIC_API_ERR];
  CLCG_REL(req);
}


@end

