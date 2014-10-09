//
//  ResultWindowController.m
//  VTest
//
//  Created by JIARUI DING on 10/7/14.
//  Copyright (c) 2014 JIARUI DING. All rights reserved.
//

#import "ResultWindowController.h"

#define INCORRECT_TABLE_TAG 0
#define PASS_TABLE_TAG 1

#define WORD_COLLUM @"word"
#define INTERPRET_COLLUM @"interpret"

@interface ResultWindowController ()

@property (strong) IBOutlet NSWindow *resultWindow;

@end

@implementation ResultWindowController

// Implement the subclass init for ResultWindowController class
-(id)init {
    _incorrectWords = [[NSMutableArray alloc] init];
    _passWords = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [_incorrectTable reloadData];
    [_passTable reloadData];

}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (tableView.tag == INCORRECT_TABLE_TAG) {
        return [_incorrectWords count];
    } else if(tableView.tag == PASS_TABLE_TAG) {
        return [_passWords count];
    }
    return 0;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    NSString *thisColumName = [tableColumn identifier];    
    NSTableCellView *thisCell = [tableView makeViewWithIdentifier:thisColumName owner:self];
    NSDictionary *thisWord = [[NSDictionary alloc] init];
    
    if (tableView.tag == INCORRECT_TABLE_TAG) {
        thisWord = [_incorrectWords objectAtIndex:row];
    } else {
        thisWord = [_passWords objectAtIndex:row];
    }
    
    if ([thisColumName isEqualToString: WORD_COLLUM]) {
        thisCell.textField.stringValue = [thisWord objectForKey:@"word"];
    }
    // Interpret Column
    else {
        thisCell.textField.stringValue = [thisWord objectForKey:@"interpret"];
    }
    
    return thisCell;
}

@end
