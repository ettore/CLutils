//
//  CLTableViewUserDefaultsController.m
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

#import "CLTableViewUserDefaultsController.h"

@implementation CLTableViewUserDefaultsController

/*" Initializes the controller with a default key, which will be changed later. 
"*/
- init
{
    if ((self = [super init]))
        [self setKey:nil]; // the key is set once the NIB is loaded
    return self;
}

/*" Writes to the user defaults and posts a notification named 
    `CLTableViewChanged' about the changes in the table view. "*/
- (void)updatePerChanges
{
    NSData *arcModel;
    
    debug0cocoa(@"CLTableViewUserDefaultsController -updatePerChanges: Saving table view data to User Defaults.... key = %@",key);
    arcModel = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[NSUserDefaults standardUserDefaults] setObject: arcModel
                                              forKey: key];
}


/*" Sets the user defaults key associated with the table view controlled. "*/
- (void) setKey:(NSString *)aKey
{
    [aKey retain];
    [key release];
    key = aKey;
}

/*" Read the user defaults  key associated with the table view controlled. "*/
- (NSString *)key { return key; }

@end
