//
//  CLUIImage.h
//  CLIPhone
//
//  Created by Ettore Pasquini on 10/11/09.
//  Copyright 2009 Cubelogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CLUIImage) 

/**
 * Returns a new image resized to the new size.
 */
+(UIImage *)imageFromImage:(UIImage *)img withSize:(CGSize)new_size;

// broken
//+(UIImage *)imageWithSize:(CGSize)new_size;

@end
