//
//  ResultWindowController.h
//  VTest
//
//  Created by JIARUI DING on 10/7/14.
//  Copyright (c) 2014 JIARUI DING. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ResultWindowController : NSWindowController<NSTableViewDataSource,NSTableViewDelegate>

@property (strong) NSMutableArray *incorrectWords;
@property (strong) NSMutableArray *passWords;

@property (weak) IBOutlet NSTableView *incorrectTable;
@property (weak) IBOutlet NSTableView *passTable;

@end
