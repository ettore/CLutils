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


#import "CLAsyncDownloader.h"

@implementation CLAsyncDownloader

@synthesize requestType = mRequestType;

- (id)init
{
    return [self initWithDelegate:nil owner:nil];
}

- (id)initWithDelegate:(id<CLDownloaderDelegate>)d owner:(id)o
{
  return [self initWithDelegate:d owner:o enableLoadingMsg:YES];
}

- (id)initWithDelegate:(id<CLDownloaderDelegate>)deleg
                 owner:(id)owner
      enableLoadingMsg:(BOOL)enableLoadingMsg
{
  if ((self = [super init]))
  {
		_downloadedData = nil;
		_expectedDownloadLength = 0;
		_busy = NO;
		_delegate = deleg;
    _owner = owner;
    mEnableLoadingMsg = enableLoadingMsg;
  }
  return self;
}

- (void)dealloc
{
  [_downloadedData release];
  [super dealloc];
}

//------------------------------------------------------------------------------
/* 
 @param url_str A string in the form http://example.com?par1=val1&par2=val2
 */ 
- (CL_ERROR)GET:(NSString*)url_str
{
  NSURLConnection *conn = nil;
  NSMutableURLRequest *req;

  assert(_delegate); // temporary sanity check
  
  if (_busy)
		return CL_BUSY;
  _busy = YES;
  
  if (mEnableLoadingMsg)
    [_delegate showSpinny];
  
  req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url_str]];
  NSString * const content_type = @"application/x-www-form-urlencoded";
  [req setValue:content_type forHTTPHeaderField:@"Content-Type"];
  [req setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
  [req setHTTPMethod:@"GET"];
  
  if (_downloadedData)
		[_downloadedData release];
  
  _downloadedData = [[NSMutableData data] retain];
  
  // download starts immediately after this call
  conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
  if (conn == nil) {
		[_downloadedData release];
		_downloadedData = nil;
		fprintf(stderr, "URL unreachable: unable to connect to server");
		return CL_CNX_UNAVAILABLE;
  }
  
  return CL_OK;
}

//------------------------------------------------------------------------------
// @param url_str A string in the form "http://example.com"
// @param post_str A string in the form "par1=val1&par2=val2" 
// We assume post_str is properly HTTP encoded and ready to go.
// 
- (CL_ERROR)POST:(NSString*)url_str withParams:(NSString*)post_str
{
  NSURLConnection *conn = nil;
  NSData *post_data;
  NSString *post_len, *cont_type = @"application/x-www-form-urlencoded";
    
  assert(_delegate); // temporary sanity check

  if (_busy)
    return CL_BUSY;
  _busy = YES;
  
  if (mEnableLoadingMsg)
    [_delegate showSpinny];
  
  // set things up for our POST request
  NSMutableURLRequest *req = [[[NSMutableURLRequest alloc] init] autorelease];
  post_data = [post_str dataUsingEncoding:NSUTF8StringEncoding];
  post_len = [NSString stringWithFormat:@"%d", [post_str length]];
  [req setURL:[NSURL URLWithString:url_str]];
  [req setHTTPMethod:@"POST"];
  [req setValue:post_len forHTTPHeaderField:@"Content-Length"];
  [req setValue:cont_type forHTTPHeaderField:@"Content-Type"];
  [req setHTTPBody:post_data];
  [req setHTTPShouldHandleCookies:YES];
    
  // if we had one download from a previous job, discard it
  if (_downloadedData)
    [_downloadedData release];
  
  _downloadedData = [[NSMutableData data] retain];

  // download starts immediately after this call
  // conn will be released by connectionDidFinishLoading connection:didFail
  conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
  if (conn == nil) {
    [_downloadedData release];
    _downloadedData = nil;
    fprintf(stderr, "URL unreachable: unable to connect to server");
    return CL_CNX_UNAVAILABLE;
  }

  return CL_OK;
}

- (CL_ERROR)PUT:(NSString*)url_str withParams:(NSString*)params
{
  NSURLConnection *conn = nil;
  NSMutableURLRequest *req;
  NSData *put_data;
  NSString *put_len, *cont_type = @"application/x-www-form-urlencoded";
  
  if (_busy)
    return CL_BUSY;
  
  if (mEnableLoadingMsg)
    [_delegate showSpinny];
  
  assert(_delegate); // temporary sanity check
  
  _busy = YES;
  req = [[[NSMutableURLRequest alloc] init] autorelease];
  
  // set things up for our PUT request
  url_str = [NSString stringWithFormat:@"%@?%@",url_str,params];
  put_data = [params dataUsingEncoding:NSUTF8StringEncoding];
  put_len = [NSString stringWithFormat:@"%d", [params length]];
  [req setURL:[NSURL URLWithString:url_str]];
  [req setHTTPMethod:@"PUT"];
  [req setValue:put_len forHTTPHeaderField:@"Content-Length"];
  [req setValue:cont_type forHTTPHeaderField:@"Content-Type"];
  [req setHTTPBody:put_data];
  [req setHTTPShouldHandleCookies:YES];
  
  // if we had one download from a previous job, discard it
  if (_downloadedData)
    [_downloadedData release];
  
  _downloadedData = [[NSMutableData data] retain];
  
  // download starts immediately after this call
  // conn will be released by connectionDidFinishLoading connection:didFail
  conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
  if (conn == nil) {
    [_downloadedData release];
    _downloadedData = nil;
    fprintf(stderr, "URL unreachable: unable to connect to server");
    return CL_CNX_UNAVAILABLE;
  }
  
  return CL_OK;
}


- (void)connection:(NSURLConnection *)cnx didReceiveResponse:(NSURLResponse *)re
{
  // this method is possibly called multiple times, like in the case of a
  // redirect, so reset received data when that happens
  _expectedDownloadLength = [re expectedContentLength];
    
  [_downloadedData setLength:0];
}

- (void)connection:(NSURLConnection *)cnx didReceiveData:(NSData *)data
{
    // append the new data to the buffer
    [_downloadedData appendData:data];
}

- (void)connection:(NSURLConnection *)cnx didFailWithError:(NSError *)err
{
  // release the connection and the data object
  [cnx release];
  [_downloadedData release];
  _downloadedData = nil;
  _busy = NO;
  
  // (to do) inform the user
  NSLog(@"Connection failed! Error - %@ %@",
        [err description],
        [[err userInfo] objectForKey:NSErrorFailingURLStringKey]);
  
  [_delegate removeSpinny];

  [_delegate downloadDidFail:self error:err];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)cnx
{
  debug0cocoa(@"@@@@ connection=%@", cnx);
  debug0msg("@@@@ NSDATA size=%d", [_downloadedData length]);
  
  [_delegate removeSpinny];
  
  [cnx release];
  [_delegate downloadDidComplete:self];
  _busy = NO;
}

- (NSData *)downloadedData
{
  return _downloadedData;
}

- (NSString *)downloadedDataAsString
{
  NSString *s = [[NSString alloc] initWithData:_downloadedData
                                      encoding:NSUTF8StringEncoding];
  [s autorelease];
  return s;
}

- (id)owner
{
  return _owner;
}

@end
