//
//  CLTableViewRecord.h
//  Created by ep on Wed Jun 18 2003.
//  Copyright (c) 2003 Ettore Pasquini.
//

/*
 This is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 This is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this software; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
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
    [muts setString:s]; // effettua retain su `s'
    //[muts retain]; //non serve perchè faccio io l'alloc
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
