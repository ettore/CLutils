//  CLTwitPicResponse.m
//  PostalChess
//  Created by Ettore Pasquini on 3/22/10.
//  Copyright 2010 Cubelogic. All rights reserved.

#import "CLTwitPicResponse.h"

@implementation CLTwitPicResponse

@synthesize status;

- (NSString *)description
{
    return [NSString stringWithFormat:@"status=%@", status];
}

@end
