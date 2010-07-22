//  CLActionSheet.h
//  CLUtils
//  Created by Ettore Pasquini on 7/21/10.
//  Copyright 2010 Cubelogic. All rights reserved.

#import <UIKit/UIKit.h>

@interface CLActionSheet : UIActionSheet {
    // this allows to use the same delegate callback for multiple alerts and 
    // easily discern which alert the invocation belongs to
    NSUInteger identifier;
}

@property(nonatomic) NSUInteger identifier;

@end
