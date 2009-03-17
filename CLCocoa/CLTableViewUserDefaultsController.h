//
//  CLTableViewUserDefaultsController.h
//  Created by ep on $Date: 2004/12/11 12:30:59 $Revision: 1.2 $
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

#import <Foundation/Foundation.h>
#import "CLTableViewController.h"

@interface CLTableViewUserDefaultsController : CLTableViewController {
/*" Specialization to handle user Defaults. Use when the table view holds
    user defaults data. NB: this implementation doesn't redefine method
    createAndAddNewEntry:, i.e. we use the default implementation provided
    by CLTableViewController (therefore creating CLSingleStringRecords).
"*/
    
    /*" Key associated with the data represented by the table view "*/
    NSString *key;
}

// accessors
- (void) setKey:(NSString *)aKey;
- (NSString *)key;

@end
