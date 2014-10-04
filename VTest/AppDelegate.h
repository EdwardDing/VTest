//
//  AppDelegate.h
//  VTest
//
//  Created by JIARUI DING on 9/28/14.
//  Copyright (c) 2014 JIARUI DING. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <FMDB/FMDatabase.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {

    FMResultSet *randList;
    FMDatabase *wordsDB;
    
    NSMutableArray *buttons;
    
    int testScale;
    int processCount;
    int index;
    int correctCount;
    int correctIndex;
}

@property (weak) IBOutlet NSTextField *ProgressLabel;
@property (weak) IBOutlet NSTextField *wordLabel;

@property (weak) IBOutlet NSButton *button1;
@property (weak) IBOutlet NSButton *button2;
@property (weak) IBOutlet NSButton *button3;
@property (weak) IBOutlet NSButton *button4;


// IBActions
- (IBAction)answerSelected:(id)sender;
- (IBAction)readCurrentWord:(id)sender;

// Supplementary Functions
-(void)loadNextWord;

void good();

@end

