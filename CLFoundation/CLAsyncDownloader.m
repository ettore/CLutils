/*
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

#import "cl_debug.h"
#import "CLAsyncDownloader.h"


////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@interface CLAsyncDownloader ()
-(CL_ERROR)doHTTP:(NSString*)method resource:(NSString*)url params:(NSString*)params;
@end

@implementation CLAsyncDownloader

@synthesize requestType = mRequestType;


- (void)dealloc
{
  mDelegate = nil;
  [mConn cancel];
  CLCG_REL(mConn);
  CLCG_REL(mDownloadedData);
  [super dealloc];
}


- (id)init
{
  return [self initWithDelegate:nil owner:nil enableLoadingMsg:YES];
}


- (id)initWithDelegate:(id<CLDownloaderDelegate>)d owner:(id)o
{
  return [self initWithDelegate:d owner:o enableLoadingMsg:YES];
}


- (id)initWithDelegate:(id<CLDownloaderDelegate>)deleg
                 owner:(id)owner
      enableLoadingMsg:(BOOL)enableLoadingMsg
{
  if ((self = [super init])) {
		mDownloadedData = nil;
		mExpectedDownloadLength = 0;
		mBusy = NO;
		mDelegate = deleg;
    mOwner = owner;
    mEnableLoadingMsg = enableLoadingMsg;
  }
  return self;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - HTTP API


/*!
 @param url_str A string in the form http://example.com?par1=val1&par2=val2
 */ 
- (CL_ERROR)GET:(NSString*)url_str
{
  NSMutableURLRequest *req;

  assert(mDelegate); // temporary sanity check
  
  if (mBusy)
		return CL_BUSY;
  mBusy = YES;
  
  if (mEnableLoadingMsg)
    [mDelegate showLoadingView:YES];
  
  req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url_str]];
  NSString * const content_type = @"application/x-www-form-urlencoded";
  [req setValue:content_type forHTTPHeaderField:@"Content-Type"];
  [req setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
  [req setHTTPShouldHandleCookies:YES];
  [req setHTTPMethod:@"GET"];
  
  [mDownloadedData release];
  mDownloadedData = [[NSMutableData data] retain];
  
  // download starts immediately after this call
  [mConn cancel];
  [mConn release];
  mConn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
  if (mConn == nil) {
		[mDownloadedData release];
		mDownloadedData = nil;
		fprintf(stderr, "URL unreachable: unable to connect to server");
		return CL_CNX_UNAVAILABLE;
  }
  
  return CL_OK;
}


-(CL_ERROR)PUT:(NSString*)url withParams:(NSString*)params
{
  url = [NSString stringWithFormat:@"%@?%@",url,params];
  return [self doHTTP:@"PUT" resource:url params:params];
}


-(CL_ERROR)POST:(NSString*)url withParams:(NSString*)params
{
  return [self doHTTP:@"POST" resource:url params:params];
}


//------------------------------------------------------------------------------
// @param url_str A string in the form "http://example.com"
// @param post_str A string in the form "par1=val1&par2=val2" 
// We assume params is properly HTTP encoded and ready to go.
// 
// currently tested only for PUT and POST
//
-(CL_ERROR)doHTTP:(NSString*)method resource:(NSString*)url params:(NSString*)params
{
  NSMutableURLRequest *req;
  NSData *data;
  NSString *len, *cont_type = @"application/x-www-form-urlencoded";
  
  if (mBusy)
    return CL_BUSY;
  mBusy = YES;
  
  if (mEnableLoadingMsg)
    [mDelegate showLoadingView:YES];
  
  req = [[[NSMutableURLRequest alloc] init] autorelease];
  data = [params dataUsingEncoding:NSUTF8StringEncoding];
  len = [NSString stringWithFormat:@"%d", [params length]];
  [req setURL:[NSURL URLWithString:url]];
  [req setHTTPMethod:method];
  [req setValue:len forHTTPHeaderField:@"Content-Length"];
  [req setValue:cont_type forHTTPHeaderField:@"Content-Type"];
  [req setHTTPBody:data];
  [req setHTTPShouldHandleCookies:YES];
  
  // NB: can't set a timeout shorter than 240 sec on POST requests (!) : code 
  // inside CFNetwork will ignore any timeout shorter than 240 sec.
  // http://stackoverflow.com/questions/1466389
  //[req setTimeoutInterval:10];
  
  // if we had one download from a previous job, discard it
  [mDownloadedData release];
  mDownloadedData = [[NSMutableData data] retain];
  
  // download starts immediately after this call
  // mConn will be released by connectionDidFinishLoading connection:didFail
  [mConn cancel];
  [mConn release];
  mConn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
  if (mConn == nil) {
    CLCG_REL(mDownloadedData);
    fprintf(stderr, "URL unreachable: unable to connect to server");
    return CL_CNX_UNAVAILABLE;
  }
  
  return CL_OK;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSURLConnectionDelegate methods


- (void)connection:(NSURLConnection *)cnx didReceiveResponse:(NSURLResponse *)re
{
  // this method is possibly called multiple times, like in the case of a
  // redirect, so reset received data when that happens
  mExpectedDownloadLength = [re expectedContentLength];
    
  [mDownloadedData setLength:0];
}


- (void)connection:(NSURLConnection *)cnx didReceiveData:(NSData *)data
{
  // append the new data to the buffer
  [mDownloadedData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)cnx
{
  CLCG_ASSERT(cnx == mConn);
  
  if ([self shouldRemoveLoadingMsg])
    [mDelegate showLoadingView:NO];
  
  CLCG_REL(mConn);
  [mDelegate downloadDidComplete:self];
  mBusy = NO;
}


- (void)connection:(NSURLConnection *)cnx didFailWithError:(NSError *)err
{
  CLCG_ASSERT(cnx == mConn);
  
  // release the connection and the data object
  CLCG_REL(mConn);
  CLCG_REL(mDownloadedData);
  mBusy = NO;
  
  // (to do) inform the user
  NSLog(@"Connection failed! Error - %@ %@",
        [err description],
        [[err userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
  
  [mDelegate showLoadingView:NO];

  [mDelegate downloadDidFail:self error:err];
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Getters


- (NSData *)downloadedData
{
  return mDownloadedData;
}


- (NSString *)downloadedDataAsString
{
  NSString *s = [[NSString alloc] initWithData:mDownloadedData
                                      encoding:NSUTF8StringEncoding];
  [s autorelease];
  return s;
}


-(BOOL)shouldRemoveLoadingMsg
{
  return YES;
}


- (id)owner
{
  return mOwner;
}


@end

