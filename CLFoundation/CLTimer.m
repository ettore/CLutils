//
//  CLTimer.m
//  SimpleTimer
//
//  Created by ep on 12/9/04.
//  Copyright 2004 Cubelogic. All rights reserved.
//

#import "CLTimer.h"
#import "cl_debug.h"

@implementation CLTimer

- (id)init
{
    return [super init];
}

- (id)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)seconds target:(id)target selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)repeats
{
    self = [super initWithFireDate:date 
                          interval:seconds
                            target:target
                          selector:aSelector
                          userInfo:userInfo
                           repeats:repeats];
    return self;
}

- (oneway void)release
{
    debug_enter("## CLTimer -release");
    [super release];
    debug_exit("## CLTimer -release");
}

@end
