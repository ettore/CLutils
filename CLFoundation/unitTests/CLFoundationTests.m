//
//  CLFoundationTests.m
//
//  Created by Ettore Pasquini on 12/14/08.
//  Copyright 2008 Cubelogic. All rights reserved.
//

#ifdef UNIT_TESTS

#define CL_UNIT_TESTS_BASE_URL "http://cubelogic.org/cgi-bin/pchess"

#import "CLFoundationTests.h"
#import "CLXMLParser.h"
#import "cl_debug.h"

void test_CLXMLParserWithStaticURL()
{
    LOG("____ test_CLXMLParserWithStaticURL ____");
    
    CLXMLParser *parser;
    NSString *url_str;
    id parsed_obj = nil;
    
    url_str = [NSString stringWithFormat:@"%s/static_user.xml", 
               CL_UNIT_TESTS_BASE_URL];
    parser = [[CLXMLParser alloc] init];
    parser.wantedTag = @"user";
    parsed_obj = [parser parseElementAtURL:url_str];
    assert(parsed_obj);
}

void test_CLXMLParserWithDummyPythonURL()
{
    LOG("____ test_CLXMLParserWithDummyPythonURL ____");
    
    CLXMLParser *parser;
    NSString *url_str = [NSString stringWithFormat:@"%s/dummy_user.py", CL_UNIT_TESTS_BASE_URL];
    id parsed_obj = nil;
    
    parser = [[CLXMLParser alloc] init];
    parser.wantedTag = @"user";
    parsed_obj = [parser parseElementAtURL:url_str];
    assert(parsed_obj);
}

// -----------------------------------------------------------------------------
void runCLFoundationTests()
{
    LOG("____ runCLFoundationTests ____");
    test_CLXMLParserWithStaticURL();
    test_CLXMLParserWithDummyPythonURL();
    LOG("____ runCLFoundationTests: finished!");
}

#endif
