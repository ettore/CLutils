/* //  Created by Ettore Pasquini on 12/11/08.

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

#import "CLXMLParser.h"
#import "cl_debug.h"
#import "CLXMLParseError.h"

@implementation CLXMLParser

@synthesize wantedTag = _wantedTag;
@synthesize errorTag = _errorTag;

- (id)init
{
    if ((self = [super init]))
    {
        _errorTag = @"error";
    }
    
    return self;
}

- (void)dealloc
{
    // we need to autorelease it only if the parser parsed something
    if (tmpParsed)
    {
        [tmpParsed autorelease];
        tmpParsed = nil;
    }
    [_errorTag release];
    [_wantedTag release];
    [_parserError release];
    [super dealloc];
}

// =============================================================================
#pragma mark -
#pragma mark Main API
// =============================================================================

// syncronous XML parsing of NSData
// clients will need to retain the returned object if they care about it.
// should also be able to return a NSArray in case there are multiple objects
- (id)parseData:(NSData *)data
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];

    [self parseWithParser:parser];
    
    [parser release];
    return tmpParsed;
}    
    
// synchronous XML download and parsing
// clients will need to retain the returned object if they care about it.
- (id)parseElementAtURL:(NSString *)url_str
{
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    NSURL *url = [[NSURL alloc] initWithString:url_str];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [self parseWithParser:parser];
    
    [parser setDelegate:nil];
    [url release];
    [parser release];
    return tmpParsed;
}

- (id)parsedElements
{
    return tmpParsed;
}

- (NSError *)parserError
{
    return _parserError;
}

// =============================================================================
#pragma mark -
#pragma mark Utils
// =============================================================================

- (void)parseWithParser:(NSXMLParser *)parser
{
    BOOL parse_successful;
    
    // tmpParsed should always be nil at this point, but if for some reason 
    // it is not nil, release whatever it's holding up to avoid leaks
    if (tmpParsed)
    {
        [tmpParsed release];
        tmpParsed = nil;
    }
    
    // same thing for the parserError
    if (_parserError)
    {
        [_parserError release];
        _parserError = nil;
    }
    
    // prepare for parsing
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    // now parse
    parse_successful = [parser parse];
    
    // check parsing results
    if (!parse_successful)
    {
        _parserError = [parser parserError];
        LOG_NS(@"%@", _parserError);
        if (_parserError)
            [_parserError retain];
        
        if (tmpParsed)
        {
            // release directly since new parsing cycle will create a new one
            [tmpParsed release];
            tmpParsed = nil;
        }
    }
}

/** Subclasses should redefine this method and return an instance of the
 *  appropriate class. */
- (id)newElementWithAttributes:(NSDictionary *)attrDict
{
#if UNIT_TESTS
    return [[NSString alloc] init]; //empty string just to indicate tests passed
#else
    return nil;
#endif
}

/** 
 * Factory method that creates an error object when a back end error occurs.
 * Subclass can override this to provide better error handling.
 */
- (id)newErrorElement:(NSDictionary *)attrDict
{
    CLXMLParseError *err = [[CLXMLParseError alloc] init];
    err.code = [[attrDict valueForKey:@"code"] integerValue];
    err.info = [attrDict valueForKey:@"info"];
    return err;
}
    

#pragma mark -
#pragma mark NSXMLParser delegate methods

// -----------------------------------------------------------------------------
// Sent when parser encounters a start tag for a given element.
//
- (void) parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elemName 
   namespaceURI:(NSString *)nsURI 
  qualifiedName:(NSString *)qName 
     attributes:(NSDictionary *)attrDict
{
    //debug0msg("elem=%s; namespace=%s; qualifiedName=%s", 
    //          [elemName UTF8String], [nsURI UTF8String], [qName UTF8String]);
    
    // if we already had a error, bail out (we could return whatever we get tho)
    if ([tmpParsed isKindOfClass:[CLXMLParseError class]])
        return;
        
    // make sure we work with no namespaces
    assert(qName == nil);
    
    if (qName)
        elemName = qName;
    
    if ([elemName isEqualToString:_wantedTag]) 
    {
        if (tmpParsed == nil)
            tmpParsed = [[NSMutableArray alloc] initWithCapacity:1];
        
        id item = [self newElementWithAttributes:attrDict];
        [(NSMutableArray*)tmpParsed addObject:item];
        [item release];
    }
    else if ([elemName isEqualToString:_errorTag])
    {
        [tmpParsed release]; // release whatever we had
        tmpParsed = [self newErrorElement:attrDict];
    }
}

// -----------------------------------------------------------------------------
//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
//{
//    debug0msg("found: %s", [string UTF8String]);
//}

// -----------------------------------------------------------------------------
- (void) parser:(NSXMLParser *)parser 
  didEndElement:(NSString *)elemName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qName
{
    // make sure we work with no namespaces
    assert(qName == nil);
    //debug0msg("end elem: %s", [elemName UTF8String]);
}

// -----------------------------------------------------------------------------
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseErr
{
    LOG("XML parse error: [%s] description: %s - %s", 
        [[parseErr domain] UTF8String], 
        [[parseErr localizedDescription] UTF8String],
        [[[parseErr userInfo] description] UTF8String]);
}

// -----------------------------------------------------------------------------
- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)err
{
    LOG("XML validation error: [%s] %s", [[err domain] UTF8String], 
        [[[err userInfo] description] UTF8String]);
}


@end
