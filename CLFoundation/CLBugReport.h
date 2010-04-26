//
//  PChessError.h
//  PostalChess
//
//  Created by Ettore Pasquini on 4/24/10.
//  Copyright 2010 Cubelogic. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CLBugReport : NSObject {
    NSString *competency;
    NSString *functionality;
    NSString *userMsg;
    NSString *info;
    NSInteger errorCode;
}

//@property(nonatomic, retain, readonly) NSString *competency;
//@property(nonatomic, retain, readonly) NSString *functionality;
//@property(nonatomic, retain, readonly) NSString *userMsg;
//@property(nonatomic, retain, readonly) NSString *info;
//@property(nonatomic, assign, readonly) NSInteger errorCode;

- (id)initWithCode:(NSInteger)code 
        competency:(NSString*)compet
     functionality:(NSString*)func
           userMsg:(NSString*)umsg 
              info:(NSString*)info;

// package up the whole error in a single string
- (NSString *)description;

- (NSString *)subject;

// package up all the information minus the subject
- (NSString *)body;

@end
