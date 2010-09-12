/* //  Created by ep on 11/18/04.

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

#import "CLURLCateg.h"

@implementation NSURL (CLURLCateg)

/*" Adjust and correct the actualUrl string with a "suitable" scheme. "*/
+ (NSString *) adjustUrlString: (NSString *)urlStr
{
    NSString *result = nil;
    NSRange range;
    
    // I must properly set the URL, e.g.:
    // if I try to open a URL w/ an unsupported scheme such as `ttp://c2.com'
    // it returns: LSOpenCFURLRef() returned -10814 for URL ttp://c2.com
    result = [urlStr stringByTrimmingCharactersInSet:
        [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (result == nil || [result isEqual:@""])
    {
        result = @"";    
    } 
    else 
    {
        range = [result rangeOfString:@"://" options:NSCaseInsensitiveSearch];
        if (range.location == NSNotFound)
            result = [@"http://" stringByAppendingString:result];
    }
    
    return result;
}

+ (NSString *) urlEncode:(NSString *)val
{
    CFStringRef s;
    
    s = CFURLCreateStringByAddingPercentEscapes(NULL, 
                                                (CFStringRef)val, 
                                                NULL, 
                                                CFSTR("?=&+"), 
                                                kCFStringEncodingUTF8);
    return [(NSString *)s autorelease];
}

@end
