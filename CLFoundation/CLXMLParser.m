//  CLXMLParser.m
//  Created by Ettore Pasquini on 12/11/08.
//  Copyright 2008 Cubelogic. All rights reserved.

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
    [super dealloc];
}

// syncronous XML parsing of NSData
// clients will need to retain the returned object if they care about it.
- (id)parseData:(NSData *)data
{
	NSXMLParser *parser;
    BOOL parse_successful;
    
    // tmpParsed should always be nil at this point, but if for some reason 
    // it is not nil, release whatever it's holding up to avoid leaks
    if (tmpParsed)
    {
        [tmpParsed release];
        tmpParsed = nil;
    }
    
	parser = [[NSXMLParser alloc] initWithData:data];
	[parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    parse_successful = [parser parse];
    debug0msg("parseData successful? %d", parse_successful);
    if (!parse_successful)
    {
        NSError *err = [parser parserError];
        NSLog(@"%@", err);
        
        if (tmpParsed)
        {
            // release directly since new parsing cycle will create a new one
            [tmpParsed release];
            tmpParsed = nil;
        }
	}
    
	// cleanup
	[parser release];
	
    return tmpParsed;
}

// syncronous XML download and parsing
// clients will need to retain the returned object if they care about it.
- (id)fetchElementAtURL:(NSString *)url_str
{
	NSURL *url;
	NSXMLParser *parser;
    BOOL parse_successful;
    
    url = [[NSURL alloc] initWithString:url_str];
    
    // tmpParsed should always be nil at this point, but if for some reason 
    // it is not nil, release whatever it's holding up to avoid leaks
    if (tmpParsed)
    {
        [tmpParsed release];
        tmpParsed = nil;
    }
    
	parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    parse_successful = [parser parse];
    debug0msg("parse successful? %d", parse_successful);
    if (!parse_successful)
    {
        NSError *err = [parser parserError];
        NSLog(@"%@", err);
        
        if (tmpParsed)
        {
            // release directly since new parsing cycle will create a new one
            [tmpParsed release];
            tmpParsed = nil;
        }
	}
    
	// cleanup
	[url release];
	[parser release];
	
    return tmpParsed;
}

- (id)parsedElement
{
    return tmpParsed;
}

/** Subclasses should redefine this method and return an instance of the
 *  appropriate class. */
- (id)createElementWithAttributes:(NSDictionary *)attrDict
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
- (id)createErrorElement:(NSDictionary *)attrDict
{
    CLXMLParseError *err = [[CLXMLParseError alloc] init];
    err.code = [[attrDict valueForKey:@"code"] integerValue];
    err.msg = [attrDict valueForKey:@"msg"];
    err.userMsg = [attrDict valueForKey:@"userMsg"];
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
    debug0msg("elem=%s; namespace=%s; qualifiedName=%s", 
              [elemName UTF8String], [nsURI UTF8String], [qName UTF8String]);
    
    // make sure we work with no namespaces
    assert(qName == nil);
    
    if (qName)
        elemName = qName;
	
    if ([elemName isEqualToString:_wantedTag]) 
        tmpParsed = [self createElementWithAttributes:attrDict];
    else if ([elemName isEqualToString:_errorTag]) 
        tmpParsed = [self createErrorElement:attrDict];
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
    debug0msg("end elem: %s", [elemName UTF8String]);
}

// -----------------------------------------------------------------------------
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseErr
{
    LOG("XML parse error: [%s] %s", [[parseErr domain] UTF8String], 
        [[[parseErr userInfo] description] UTF8String]);
}

// -----------------------------------------------------------------------------
- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)err
{
    LOG("XML validation error: [%s] %s", [[err domain] UTF8String], 
        [[[err userInfo] description] UTF8String]);
}


@end
