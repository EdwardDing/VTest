//
//  AppDelegate.h
//  VTest
//
//  Created by JIARUI DING on 9/28/14.
//  Copyright (c) 2014 JIARUI DING. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ResultWindowController.h"
#import <FMDB/FMDatabase.h>

#define PASS_BUTTON_TAG 4

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    ResultWindowController *resultWindowController;
    
    // Data Base
    FMResultSet *randList;
    FMDatabase *wordsDB;
    
    NSMutableArray *buttons;
    
    // Progress Control Parameters
    int testScale;
    int processCount;
    
    // Grade & Result Parameters
    int correctCount;
    int correctIndex;
    int passCount;
}

@property (weak) IBOutlet NSTextField *ProgressLabel;
@property (weak) IBOutlet NSTextField *wordLabel;
@property (weak) IBOutlet NSTextField *phoneticLabel;
@property (weak) IBOutlet NSTextField *scaleLabel;

@property (weak) IBOutlet NSButton *button1;
@property (weak) IBOutlet NSButton *button2;
@property (weak) IBOutlet NSButton *button3;
@property (weak) IBOutlet NSButton *button4;
@property (weak) IBOutlet NSButton *passButton;


// IBActions
- (IBAction)answerSelected:(NSButton *)sender;
- (IBAction)readCurrentWord:(NSButton *)sender;

// Supplementary Functions
-(void)loadNextWord;

void good();

@end

