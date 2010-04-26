//
//  PChessError.m
//  PostalChess
//
//  Created by Ettore Pasquini on 4/24/10.
//  Copyright 2010 Cubelogic. All rights reserved.
//

#import "CLBugReport.h"

@implementation CLBugReport

//@synthesize competency;
//@synthesize functionality;
//@synthesize userMsg;
//@synthesize info;
//@synthesize errorCode;

- (id)initWithCode:(NSInteger)code 
        competency:(NSString*)compet
     functionality:(NSString*)func
           userMsg:(NSString*)umsg 
              info:(NSString*)infomsg
{
    if ((self = [super init]))
    {
        competency = compet;
        functionality = func;
        errorCode = code;
        userMsg = umsg;
        info = infomsg;
        if (competency)
            [competency retain];
        if (functionality)
            [functionality retain];
        if (userMsg)
            [userMsg retain];
        if (info)
            [info retain];
    }
    return self;
}

- (NSString *)subject
{
    return functionality;
}

- (NSString *)body
{
    NSString *s;
    s = [NSString stringWithFormat:
         @"Competency =\n%@\n\nErrorCode =\n%d\n\nUserMsg =\n%@\n\nInfo =\n%@\n",
         competency, errorCode, userMsg, info];
    return s;
}

- (NSString *)description
{
    NSString *s;
    s = [NSString stringWithFormat:@"Subject =\n%@\n\n%@",[self subject], [self body]];
    return s;
}

- (void)dealloc
{
    [competency release];
    [functionality release];
    [userMsg release];
    [info release];
    [super dealloc];
}

@end
