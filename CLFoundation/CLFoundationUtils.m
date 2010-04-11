/*
 *  CLFoundationUtils.m
 *  Created by Ettore Pasquini on 8/3/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 */

#import "CLFoundationUtils.h"

Boolean isEmpty(NSString *s)
{
    return (s == nil || [s compare:@""] == NSOrderedSame);
}

// used for archiving defaults as NSData
NSData* arc(id foo) 
{
	return [NSKeyedArchiver archivedDataWithRootObject:foo];
}

// unarchive NSData from defaults
id unarc(NSString* key)
{
	NSData* temp = [[NSUserDefaults standardUserDefaults] dataForKey:key];
	if (temp == nil)
        return nil;
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:temp];
}

