//
//  CLTableViewController.h
//  Created by ep on $Date: 2004/12/11 12:30:59 $Revision: 1.2 $

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

#import <Cocoa/Cocoa.h>
#import "CLController.h"
@class CLTableViewRecord;

@interface CLTableViewController : NSObject <CLController> {
    IBOutlet NSTableView *tableView;
    IBOutlet NSButton *deleteButton;

    /*" The model is the data structure that holds the data visualized by
        the table view. In this case, this structure is a mutable array
        of mutable strings. "*/
    NSMutableArray *model;
}

// Action Methods
- (IBAction)deleteEntry:(id)sender;
- (IBAction)addEmptyEntry:(id)sender;

// Data source methods: declared in the NSTableDataSource informal protocol
- (int) numberOfRowsInTableView:(NSTableView *)aTableView;
- (id) tableView:(NSTableView *)aTableView
             objectValueForTableColumn: (NSTableColumn *)aTableColumn
             row: (int)rowIndex;
- (void) tableView: (NSTableView *)aTableView
    setObjectValue: (id)anObject
    forTableColumn: (NSTableColumn *)aTableColumn
               row: (int)rowIndex;

// Delegate methods (declared in the NSTableViewDelegate informal protocol)
- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(int)rowIndex;
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification;

// other methods
- (NSTableView *)tableView;
- (NSMutableArray *)modelAsArray;
- (void)updateTV;

//////////////////////////////////////////////////////////////
// SUBCLASSES MAY NEED TO REDEFINE THESE APIS
//////////////////////////////////////////////////////////////
- (void)createAndAddNewEntry; // This is a factory method
- (void)updateBtnStatus;
- (void)startObservingRecord: (CLTableViewRecord *)rec;
- (void)stopObservingRecord: (CLTableViewRecord *)rec;
@end
