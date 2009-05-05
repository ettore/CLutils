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
    NSString *_msg; // technical description of error
    NSString *_userMsg; // user friendly description
}

@property(nonatomic) NSInteger code;
@property(nonatomic, retain) NSString    *msg;
@property(nonatomic, retain) NSString    *userMsg;

@end
