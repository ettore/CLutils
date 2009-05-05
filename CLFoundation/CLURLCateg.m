//
//  CLURLCateg.m
//  Created by ep on 11/18/04.
//  Copyright 2004 Cubelogic. All rights reserved.
//

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
