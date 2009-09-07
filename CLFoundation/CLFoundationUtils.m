/*
 *  CLFoundationUtils.m
 *  Created by Ettore Pasquini on 8/3/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 */

Boolean isEmpty(NSString *s)
{
    return (s == nil || [s compare:@""] == NSOrderedSame);
}
