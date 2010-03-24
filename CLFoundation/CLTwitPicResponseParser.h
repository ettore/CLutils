//
//  CLTwitPicResponseParser.h
//  PostalChess
//
//  Created by Ettore Pasquini on 3/22/10.
//  Copyright 2010 Cubelogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLXMLParser.h"

@interface CLTwitPicResponseParser : CLXMLParser 
{
}

/** factory method that should return an instance of the appropriate class. */
- (id)createElementWithAttributes:(NSDictionary *)attrDict;

@end
