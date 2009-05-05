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
@synthesize msg = _msg;
@synthesize userMsg = _userMsg;

-(NSString *)description
{
    return [NSString stringWithFormat:@"Error code=%d msg=%@ userMsg=%@", 
                self.code, self.msg, self.userMsg];
}

@end
