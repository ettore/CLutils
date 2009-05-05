//
//  CLURLCateg.h
//  Created by ep on 11/18/04.
//  Copyright 2004 Cubelogic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (CLURLCateg) 

/* Trims and adds "http://" scheme info if missing. */ 
+ (NSString *) adjustUrlString: (NSString *)urlStr;

/* Encodes weird chars with % escapes codes for proper HTTP submission. */
+ (NSString *) urlEncode:(NSString *)val;

@end
