//
//  CLTableViewController.h
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
