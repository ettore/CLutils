//  Created by ep on Wed Jun 18 2003.
/*
 Copyright (c) 2003, Cubelogic. All rights reserved.
 
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

#import "CLTableViewRecord.h"


@implementation CLTableViewRecord
@end


@implementation CLSingleStringRecord

// **********************************************
// INITIALIZERS & DEALLOCATION METHODS
// **********************************************

/*" Creates a record with a blank string"*/
- (id) init {
    return [self initWithString:@""];
}

/*" this is the designated initializer "*/
- (id) initWithString:(NSString *)s
{
    if ((self = [super init]))
        [self setString:s];
    return self;
}

- (void) dealloc {
    [string release];
    [super dealloc];
}

// **********************************************
// GETTER AND SETTER METHODS
// **********************************************

- (NSMutableString *) string { return string; }

- (void)setString: (NSString *)s {
    NSMutableString *muts = [[NSMutableString alloc] init];
    [muts setString:s];
    [string release];
    string = muts;
}


// **********************************************
// NSCODING METHODS
// **********************************************

/*" 
Called by the object that "owns" the receiver. 
(if the CLTableViewRecord instance is part of a larger structure who's being 
encoded, then this method will be called.)
"*/
- (void)encodeWithCoder:(NSCoder *)encoder
{
    //if the superclass (NSObject) conformed to NSCoding I'd have to encode the
    //superclass data. But NSObject does not conform to NSCoding.
    //[super encodeWithCoder:encoder];
    [encoder encodeObject:string];
}


- (id)initWithCoder:(NSCoder *)decoder
{
    // if CLTableViewRecord's superclass had implemented the NSCoding protocol,
    // I would have needed to call ``[super initwithCoder:coder]'' instead 
    // of [super init]
    if ((self = [super init])) {
        [self setString:[decoder decodeObject]];
    }
    return self;
}


// **********************************************
// REDEFINED METHODS
// **********************************************

- (NSString *) description
{
    return string;
}

- (BOOL)isEqual:(id)anObject
{
    return ([[self description] isEqual:[anObject description]]);
}

- (unsigned)hash
{
    return [string hash];
}

@end
