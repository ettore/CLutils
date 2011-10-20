//
//  cl_chess_foundation.m
//  Created by Ettore Pasquini on 2/28/11.
//  Copyright 2011 Cubelogic. All rights reserved.
//

#import "cl_chess_foundation.h"
#import <CoreFoundation/CoreFoundation.h>

BOOL isWhiteTurn(CFStringRef fen)
{
  NSArray *arr = [(NSString*)fen componentsSeparatedByString:@" "];
  if (arr == nil || [arr count] < 2)
    return NO;
  
  // 2nd comp of FEN is the active color in the game: 'w' or 'b'
  return [[arr objectAtIndex:1] isEqualToString:@"w"];
}
