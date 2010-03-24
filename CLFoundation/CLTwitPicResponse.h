//
//  CLTwitPicResponse.h
//  PostalChess
//
//  Created by Ettore Pasquini on 3/22/10.
//  Copyright 2010 Cubelogic. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CLTwitPicResponse : NSObject {
@private
    NSString    *status;
}

@property(nonatomic, retain) NSString    *status;

@end
