//  CLController.h
//  Created by ep on $Date: 2004/12/11 12:30:59 $Revision: 1.2 $
//  Copyright (c) 2003 Ettore Pasquini
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

