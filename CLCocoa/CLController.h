//  CLController.h
//  Created by ep on $Date: 2004/12/11 12:30:59 $Revision: 1.2 $
//  Copyright (c) 2003 Ettore Pasquini
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

@class CLTableViewRecord;

@protocol CLController
/*" 
This is a generic protocol to define a controller of a record container
object (such as an array or dictionary) who is displayed on the GUI using a 
graphical widget, such as a NSTableView or similar.
"*/

/*" Returns the data model object controlled by this controller. "*/
- (id) model;

/*" Sets the data model object controlled by this controller. "*/
- (void) setModel:(id)newModel;

/*" 
Updates the UI to reflect changes in the data model. E.g., on 
NSTableViews,this method would invoke reloadData on the NSTableView.
"*/
- (void) updateUI;

/*" 
Same as updateUI, but operates on the result of a notification.
"*/
- (void)updateUIWith:(NSNotification *)notif;

/*" 
This method should be called after every modification done on the displayer 
object. (E.g., on NSTableViews the user can modify the records by operating 
on the table view itself.) Implementations should use this method 
to execute further actions consequent to a modification. 
"*/
- (void) updatePerChanges;

/*" Adds a record to the data model."*/
- (void) addRecord: (CLTableViewRecord *)rec;

@end

