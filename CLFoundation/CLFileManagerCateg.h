//
//  CLFileManagerCateg.h
//  Created by ep on 11/19/04.
//  Copyright 2004 Cubelogic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (CLFileManagerCateg) 

+ (NSMutableArray *)extractFromAbsPath:(NSString *)absPath
                             removeExt:(BOOL)extFlag;

+ (NSString *)removeExtFrom:(NSString *)fname;

- (NSArray *)listOfFilenamesAt:(NSString *)dirName 
                       withExt:(NSArray *)fileTypes
                     removeExt:(BOOL)extFlag;

@end

