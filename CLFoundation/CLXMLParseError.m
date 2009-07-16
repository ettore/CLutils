//
//  CLXMLParseError.m
//  PostalChess
//
//  Created by Ettore Pasquini on 12/15/08.
//  Copyright 2008 Cubelogic. All rights reserved.
//

#import "CLXMLParseError.h"

@implementation CLXMLParseError

@synthesize code = _code;
@synthesize info = _info;

-(NSString *)description
{
    return [NSString stringWithFormat:@"Error code=%d info=%@", _code, _info];
}

@end
