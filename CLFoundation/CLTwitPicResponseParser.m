//
//  CLTwitPicResponseParser.m
//  PostalChess
//  Created by Ettore Pasquini on 3/22/10.
//  Copyright 2010 Cubelogic. All rights reserved.

#import "CLTwitPicResponseParser.h"
#import "CLTwitPicResponse.h"
#import "cl_debug.h"

@implementation CLTwitPicResponseParser

- (id)init
{
    if ((self = [super init]))
    {
        self.wantedTag = @"rsp";
    }
    return self;
}

/** Subclasses should redefine this method and return an instance of the
 *  appropriate class. */
- (id)createElementWithAttributes:(NSDictionary *)attrDict
{
    CLTwitPicResponse *rsp = [[CLTwitPicResponse alloc] init];
    NSObject *status = [attrDict valueForKey:@"status"];
    NSObject *stat = [attrDict valueForKey:@"stat"];
    debug0cocoa(@"STATUS=%@ STAT=%@", status, stat);
    if (status)
        rsp.status = [status description];
    else if (stat)
        rsp.status = [stat description];
    else
        rsp.status = nil;

    return rsp;
}

@end
