//
//  CLXMLParseError.h
//  PostalChess
//
//  Created by Ettore Pasquini on 12/15/08.
//  Copyright 2008 Cubelogic. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CLXMLParseError : NSObject {
@private
    NSInteger _code; // error code
    NSString *_info; // technical info of error
}

@property(nonatomic) NSInteger code;
@property(nonatomic, retain) NSString *info;

@end
