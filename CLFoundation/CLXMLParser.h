//  CLXMLParser.h
//  Created by Ettore Pasquini on 12/11/08.
//  Copyright 2008 Cubelogic. All rights reserved.

#import <Foundation/Foundation.h>


@interface CLXMLParser : NSObject <NSXMLParserDelegate>
{
@private
    id tmpParsed; // array of instances created by createElementWithName
    NSString *_wantedTag; // the main element tag we're looking for
    NSString *_errorTag; // if an error occurs on backend, we'll get a error tag
    NSError *_parserError; // if not nil, we could not parse the content.
                           // Note the difference with CLXMLError, which is a
                           // backend app error which produces no XML parse error.
}

@property(nonatomic, retain) NSString *wantedTag;
@property(nonatomic, retain) NSString *errorTag;

/**
 * Synchronous XML download and parsing. 
 * Returns the parsed element or an instance of the CLXMLParseError hierarchy. 
 * Clients will need to retain the returned object if they care about it. */
- (id)parseElementAtURL:(NSString *)url_str;

/**
 * Parse XML from 'data'. Synchronous.
 * @return The parsed element or an instance of the CLXMLParseError hierarchy. 
 * Clients will need to retain the returned object if they care about it. */
- (id)parseData:(NSData*)data;

/** 
 * Factory method that should instantiate and return an instance of the
 * appropriate class. Clients do not need to invoke this method. This
 * method is used by the parser and its result ultimately is available 
 * via the parsedElement method. Returned object follows ownership rule.
 */
- (id)createElementWithAttributes:(NSDictionary *)attrDict;

/**
 * Factory method that creates an instance of a CLXMLParseError.
 * This is invoked when the backend returns a <error/> message.
 * Returned object follows ownership rule.
 */
- (id)createErrorElement:(NSDictionary *)attrDict;

/** Returns the parsed elements from the last parseElementAtURL: invocation. 
 *  This can be an array of instances of a user class 
 *  (see createElementWithAttributes: method) or an instance of the 
 *  CLXMLParseError hierarchy. If a new parsing cycle is started
 *  (with parseElementAtURL:) this object gets released, so clients should
 *  retain this if they care about it.
 *  Note to self: The parsed element will eventually be autoreleased like any 
 *  other cocoa class; this happens when the CLXMLParser is deallocated. */
- (id)parsedElements;

- (NSError *)parserError;

- (void)parseWithParser:(NSXMLParser *)parser;

// -----------------------------------------------------------------------------
#pragma mark Delegate methods for NSXMLParser
// -----------------------------------------------------------------------------

// subclasses should redefine this method providing additional parsing as
// necessary. This class only intantiate the initial object corresponding 
// to the wantedTag tag using the createElementWithAttributes: factory method.
- (void) parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elemName 
   namespaceURI:(NSString *)nsURI 
  qualifiedName:(NSString *)qName 
     attributes:(NSDictionary *)attrDict;

- (void) parser:(NSXMLParser *)parser 
  didEndElement:(NSString *)elemName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qName;

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseErr;

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)err;


@end
