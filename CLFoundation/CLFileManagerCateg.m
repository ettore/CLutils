/*//  Created by ep on 11/19/04.
 Copyright (c) 2010, Cubelogic. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without 
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, 
 this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, 
 this list of conditions and the following disclaimer in the documentation 
 and/or other materials provided with the distribution.
 * Neither the name of Cubelogic nor the names of its contributors may be 
 used to endorse or promote products derived from this software without 
 specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE.
 */

#import "CLFileManagerCateg.h"
#import "cl_debug.h"

/*" 
Returns a couple expressed as an array containing 2 elements: 
the first is the directory, the second is the filename. 
This method guarantees to always return an autoreleased array with exactly
2 elements.
"*/
@implementation NSFileManager (CLFileManagerCateg)

+ (NSMutableArray *)extractFromAbsPath: (NSString *)absPath 
                             removeExt: (BOOL)extFlag
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:2];
    NSString *fname;
    
    // range.location , range.length for the occurrance of "/"
    // if "/" not found, returns a range== {NSNotFound, 0}
    NSRange range = [absPath rangeOfString:@"/" 
                                   options:NSBackwardsSearch];
    
    if (range.location == NSNotFound)
    {
        [arr addObject: @""]; // dir 
        fname = absPath; // filename
    }
    else {
        // from 0 to index:
        [arr addObject:[absPath substringToIndex:(range.location+1)]]; // dir 
        // from index to end:
        fname = [absPath substringFromIndex:(range.location+1)]; // filename
    }

    if (extFlag)
        fname = [NSFileManager removeExtFrom:fname];

    [arr addObject: fname]; // filename
    
    return arr;        
}

/*" 
Returns a string containing the filename `fname' without its extension. 
Only the extension is removed: if fname is a fully qualified path, the 
returned string will include the path and the actual filename, minus the
extension. To remove the directory path, see extractFromAbsPath:removeExt:.
"*/
// check out [NSString -stringByDeletingPathExtension]
+ (NSString *)removeExtFrom:(NSString *)fname
{
    // range.location , range.length search for "."
    NSRange range = [fname rangeOfString:@"." 
                                 options:NSBackwardsSearch];
    if (range.location != NSNotFound)
        fname = [fname substringToIndex:range.location];                
    debug0cocoa(@"removeExtFrom: returned fname = %@", fname);
    return fname;
}

/*" Returns an array of the files included in `dirName' complying with the 
extensions specified by `fileTypes'. 
[The elements of `fileTypes' must be 
properly ordered, that is, for extensions "AIF", "AIFF", etc., the proper 
order is "AIFF", "AIF"]
"*/
- (NSArray *)listOfFilenamesAt:(NSString *)dirName 
                       withExt:(NSArray *)fileTypes
                     removeExt:(BOOL)extFlag
{
    NSArray *allFiles = [self directoryContentsAtPath:dirName];
    NSMutableArray *allowedFiles = [NSMutableArray array];
    int n = [allFiles count] - 1;
    int totalTypes = [fileTypes count];
    int i;
    NSString *fname;
    
    for (; n>=0; n--)
    {
        fname = [allFiles objectAtIndex:n];
        i=0;
        while (i < totalTypes)
        {
            if ([fname hasSuffix: [fileTypes objectAtIndex:i]])
            {
                if (extFlag)
                    fname = [NSFileManager removeExtFrom:fname];

                [allowedFiles addObject: fname];
                break;
            }
            i++;
        }
    }
    return allowedFiles;
}

@end
