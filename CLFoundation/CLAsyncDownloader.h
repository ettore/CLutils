// Copyright 2008 Cubelogic. All rights reserved.

#import <Foundation/Foundation.h>
#import "cl_errors.h"

@class CLAsyncDownloader;

@protocol CLDownloaderDelegate

- (void)downloadDidComplete:(CLAsyncDownloader *)d;

@end

/*"
 Use an instance of this class to download one item at a time using HTTP GET.
 "*/
@interface CLAsyncDownloader : NSObject
{
@private
	NSMutableData   *_downloadedData;
	long long        _expectedDownloadLength;
	BOOL             _busy;
	NSObject<CLDownloaderDelegate>   *_delegate;
    id               _owner;
}

// -----------------------------------------------------------------------------
#pragma mark * Main API * 

// possible patterns: factory, flyweight, builder
// Creates the downloader without starting any download.  The "owner" is the
// object that conceptually will own the downloaded data.
- (id)initWithDelegate:(NSObject<CLDownloaderDelegate> *)delegate  
                 owner:(id)owner;

/* 
 Sends a request for a URL.  When the content is downloaded and available, 
 a callback on the delegte will be invoked.
 @param url_str A string in the form http://example.com?par1=val1&par2=val2
 @return CL_BUSY if already downloading something.
 */ 
- (CL_ERROR)requestURLusingGET:(NSString*)urlStr;

/* 
 @param url_str A string in the form "http://example.com"
 @param post_str A string in the form "par1=val1&par2=val2"
 We assume post_str is properly HTTP encoded and ready to go.
 */ 
- (CL_ERROR)requestURL:(NSString*)url_str usingPOSTparams:(NSString*)post_str;

// returns the downloaded data 
- (NSData *)downloadedData;

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
