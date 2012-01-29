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


#import <Foundation/Foundation.h>
#import "cl_errors.h"

@class CLAsyncDownloader;


//------------------------------------------------------------------------------
#pragma mark -

@protocol CLDownloaderDelegate

@required
-(void)downloadDidComplete:(CLAsyncDownloader *)d;
-(void)downloadDidFail:(CLAsyncDownloader *)d error:(NSError *)err;
-(void)showSpinny;
-(void)removeSpinny;

@optional 
-(NSString*)loadingMessage;
@end


//------------------------------------------------------------------------------
#pragma mark -


/*"
 Use an instance of this class to download one item at a time using HTTP GET.
 "*/
@interface CLAsyncDownloader : NSObject
{
@private
  NSMutableData   *_downloadedData;
  long long        _expectedDownloadLength;
  BOOL             _busy;
  id<CLDownloaderDelegate> _delegate;
  id               _owner;
  int              mRequestType;
  BOOL             mEnableLoadingMsg;
}

// -----------------------------------------------------------------------------
#pragma mark * Main API * 

@property(nonatomic) int requestType;

/**
 * possible patterns: factory, flyweight, builder
 * Creates the downloader without starting any download.  The "owner" is the
 * object that conceptually will own the downloaded data. 
 */
- (id)initWithDelegate:(id<CLDownloaderDelegate>)d owner:(id)o;

- (id)initWithDelegate:(id<CLDownloaderDelegate>)d 
                 owner:(id)o 
      enableLoadingMsg:(BOOL)flag;

/* 
 Sends a request for a URL.  When the content is downloaded and available, 
 a callback on the delegte will be invoked.
 @param url_str A string in the form http://example.com?par1=val1&par2=val2
 @return CL_BUSY if already downloading something.
 */ 
- (CL_ERROR)GET:(NSString*)urlStr;

/* 
 @param url_str A string in the form "http://example.com"
 @param post_str A string in the form "par1=val1&par2=val2"
 We assume post_str is properly HTTP encoded and ready to go.
 */ 
- (CL_ERROR)POST:(NSString*)url_str withParams:(NSString*)post_str;

- (CL_ERROR)PUT:(NSString*)url_str withParams:(NSString*)post_str;


// returns the downloaded data 
- (NSData *)downloadedData;

// returns the downloaded data as string
- (NSString *)downloadedDataAsString;

// subclasses can override this method to prevent the receiver from removing
// the loading message when downloading ends. Returns YES by default.
- (BOOL)shouldRemoveLoadingMsg;

// -----------------------------------------------------------------------------
#pragma mark * Utils * 

// returns the owner of the downloaded data
- (id)owner;

// delegate methods
- (void)connection:(NSURLConnection *)cnx didReceiveResponse:(NSURLResponse *)re;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)cnx didFailWithError:(NSError *)err;
- (void)connectionDidFinishLoading:(NSURLConnection *)cnx;

@end
