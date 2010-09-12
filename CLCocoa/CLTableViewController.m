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

#import "CLTableViewController.h"
#import "CLTableViewRecord.h"
#import "CLTimerSummary.h"

@implementation CLTableViewController
/*"
This class implements a general controller for an NSTableView.
This version is meant to be as the simplest (yet fully functional) possible 
case of an NSTableView controller: it supports a table view of just one column 
whose records (i.e. rows) are instances of `CLSingleStringRecord', a wrapper 
for NSMutableString.

Nevertheless, this controller can manage a generic kind of records, once it is
provided with:

(1) a specialized version of `createAndAddNewEntry:'; 
(2) a custom record type, subclass of `CLTableViewRecord'; 
(3) `Identifier' tags on the table view columns in IB matching the attributes 
    names of the custom record type. 

The specialized `createAndAddNewEntry:' will provide the way to create a new 
record (i.e. a new row) on the tableView. The specialized 
`createAndAddNewEntry:' must add the new record 
(a instance of a subclass of CLTableViewRecord) to the `model': an
easy way to do so is using the `addRecord:' method.

See CLTableViewUserDefaultsController for an extended version of this class
capable to manage the case of a tableview handling user defaults.
"*/

// **********************************************
// Initializations and deallocations
// **********************************************

/*" Designated initializer. "*/
- (id)init
{
    if ((self = [super init]))
	{
        model = [[NSMutableArray alloc] init];
        //[self createAndAddNewEntry]; // create a default record
    }
    return self;
}


- (void)dealloc
{
    [model release];
    [super dealloc];
}


// **************
// Action Methods
// **************

- (IBAction)deleteEntry:(id)sender;
{
    NSEnumerator *selRows = [tableView selectedRowEnumerator];
    int numberOfRemovedElem = 0; //counts the # of removed elements
    int i;

    NSArray *arr = [selRows allObjects];
    for (i=0; i<[arr count]; i++) {
        //to get the right index I must consider that every time I remove an 
        // element, all the following elements shift down: so I just have to 
        // subtract the number of deleted elements.
        [model removeObjectAtIndex:([[arr objectAtIndex:i] intValue] - numberOfRemovedElem++)];
        [self updatePerChanges];
        [self updateUI];
    }
}

/*" Calls the createAndAddNewEntry: factory method. "*/
- (IBAction)addEmptyEntry:(id)sender
{
    [self createAndAddNewEntry];
    [self updatePerChanges];
    [self updateUI];
}



// *********************************************************
//                  DATA SOURCE METHODS
//
// (CLTableViewController   il data source della TableView)
// (Questi metodi sono chiamati automaticamente)
// *********************************************************

/*" ritorna il numero di righe della TableView "*/
- (int) numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [model count];
}


/*"
 ritorna il valore dell'oggetto individuato dalla colonna `aTableColumn' alla
 riga `rowIndex'
"*/
- (id) tableView: (NSTableView *)aTableView
objectValueForTableColumn: (NSTableColumn *)aTableColumn
             row: (int)rowIndex
{
    // get the ``identifier'' specified in IB for each column
    NSString *identifier = [aTableColumn identifier];
    // get the row #rowIndex
    id rec = [model objectAtIndex:rowIndex];
    // return value of var. whose name is the value of the string `identifier'
    return [rec valueForKey:identifier];
}


/*"
setta a `anObject' la cella individuata dalla riga `rowIndex' di `aTableColumn'; 
`obj' contiene l'editing fatto dall'utente sulla GUI.
Ogni volta che finisce l'editing su una cella sulla GUI questo metodo viene 
chiamato: al suo interno aggiorno le mie strutture dati (the "Model" (MVC)) in 
modo opportuno.
 "*/
- (void)tableView:(NSTableView *)aTableView
        setObjectValue: (id)obj
        forTableColumn: (NSTableColumn *)aTableColumn
        row: (int)rowIndex
{
    NSString *identifier = [aTableColumn identifier];
    id rec = [model objectAtIndex:rowIndex];
    //set the value `obj' for attr. of `rec' named as the value of `identifier'
    [rec takeValue:obj forKey:identifier];
    [self updatePerChanges]; // issue the changes to everyone who need
}



// ******************************************************
//                  DELEGATE METHODS
// (CLTableViewController   il delegate della TableView)
// ******************************************************

/*" Stabilisce se l'utente pu˜ selezionare una generica riga o se ci sono
    limitazioni. Questo metodo  chiamato automaticamente.
    Returns YES to permit aTableView to select the row at rowIndex,
    NO to deny permission. The delegate can implement this method to disallow
    selection of particular rows.
"*/
- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(int)rowIndex
{
    return YES;
}


/*" Informs the delegate that the NSTableView's selection has changed.
    Calls updateBtnStatus.
    Questo metodo  chiamato automaticamente. 
"*/
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    [self updateBtnStatus];
}


// **********************************************
// GETTER AND SETTER METHODS
// **********************************************

- (NSTableView *)tableView { return tableView; }

- (id) model { return model; }

- (void) setModel:(id)newModel
{
    [newModel retain];
    [model release];
    model = newModel;
    [self updatePerChanges];
    [self updateUI];
}

// **********************************************
// OTHER METHODS
// **********************************************

- (NSMutableArray *)modelAsArray { return model; }

/*" Reload data on the table view and update the status of the buttons. "*/
- (void)updateUI
{
    [tableView reloadData];
    [self updateBtnStatus];
}

/*" Reload data on the table view. "*/
- (void)updateTV
{
    [tableView reloadData];
}

/*" Reloads data on the table view. "*/
- (void)updateUIWith:(NSNotification *)notif
{
    [tableView reloadData];
}

/*" 
Updates the status of the button controlling the tableview 
Controlla che il # di rec. non sia arrivato a 0
(ad es. in seguito a cancellazioni): se  0, disabilita il deleteButton.
Subclass controllers who have more button need to redefine this method
only, leaving `updateUI' and `tableViewSelectionDidChange:' unaltered).
"*/ 
- (void)updateBtnStatus
{
    [deleteButton setEnabled:(([model count] > 0) &&
                              ([tableView selectedRow] != -1) ) ];
}

/*" 
Called after every modification on the table view. Redefine this method 
to execute further actions consequent to a modification. 
This version does nothing. 
"*/
- (void)updatePerChanges
{}


/*" 
Creates an empty (or default initialized) record that wil be added to the 
NSTableView. 
This is factory method (see `Factory Pattern' on the D.P. book): this 
version creates `CLSingleStringRecord' objects, initialized as per the 
title of the first column of the table view. As you can see by the  
`CLSingleStringRecord' specification and documentation, this method is 
suitable for table views composed of just one column, whose elements are 
strings. A more generic table view only needs to redefine this method, or
use addRecord: instead. 
"*/
- (void) createAndAddNewEntry
{
    NSString *s = 
        [[NSBundle mainBundle] localizedStringForKey:@"NewEntry" 
                                               value:@"New Entry"
                                               table:@"CLCommonLocalizable"];
    CLSingleStringRecord *r = [[CLSingleStringRecord alloc] initWithString:s];
    [model addObject:r]; //ora l'oggetto puntato da s ha retain count=2 ...
    [r release]; //... quindi lo rilascio
}


/*" Adds a record to the model represented by table view. Unless one wants 
to change the model and the way records (i.e. rows) are managed, this method 
should not be redefined. "*/
- (void)addRecord:(CLTableViewRecord *)rec
{
    debug_enter("addRecord");
    [model addObject:rec];
    [self updatePerChanges];
    [self updateUI];
    //[self startObservingRecord: rec];
}

- (void)startObservingRecord: (CLTableViewRecord *)rec {}
- (void)stopObservingRecord: (CLTableViewRecord *)rec {}

@end
