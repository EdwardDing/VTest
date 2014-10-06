//
//  AppDelegate.m
//  VTest
//
//  Created by JIARUI DING on 9/28/14.
//  Copyright (c) 2014 JIARUI DING. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // Initialize
    testScale = 50;
    processCount = 0;
    buttons = [[NSMutableArray alloc]initWithObjects:_button1,_button2,_button3,_button4,nil];
    
    // Binding buttons with keys
    for (NSButton *ansButton in buttons) {
            [ansButton setKeyEquivalent:
             [NSString stringWithFormat:@"%ld",
              (long)[ansButton tag] + 1]];
    }
    [_passButton setKeyEquivalent:@" "];
    
    // load Data Base
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"wordlist" ofType:@"sqlite"];
    wordsDB = [[FMDatabase alloc] initWithPath:dbPath];
    if (![wordsDB open]) {
        NSLog(@"Open failed, no avaliable resources");
    }
    
    // Execute SQL to create a random wordlist with scale of testScale
    NSString *sql_randWithScale = [NSString stringWithFormat:@"SELECT * FROM basic_wordlist ORDER BY RANDOM() limit %d", testScale];
    randList = [wordsDB executeQuery:sql_randWithScale];
    
    [self loadNextWord];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)answerSelected:(id)sender {
    if ([sender tag] == correctIndex) {
        correctCount++;
    } else if ([sender tag] == PASS_BUTTON_TAG) {
        passCount++;
    }
    
    if (processCount < testScale) {
        [self loadNextWord];
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Finished!"
                                         defaultButton:@"OK"
                                       alternateButton:@"Cancel"
                                           otherButton:nil
                             informativeTextWithFormat:@"%d Correct, %d Passes", correctCount, passCount];
        [alert runModal];
    }
}

- (void)loadNextWord{
    
    // Set the word and phonetic
    [randList next];
    [_wordLabel setStringValue:[randList stringForColumn:@"word"]];
    [_phoneticLabel setStringValue:[randList stringForColumn:@"phonetic"]];
    
    
    // randomly choose a place to put the right answer & fill the other
    // places with other wrong definitions.
    correctIndex = arc4random() % 4;
    FMResultSet *wrongAns = [wordsDB executeQuery:@"select interpret from basic_wordlist order by random() limit 3"];
    
    for (int i = 0; i < [buttons count]; i++) {
        if (i == correctIndex) {
            [buttons[i] setTitle:[[randList stringForColumn:@"interpret"]
                                  stringByTrimmingCharactersInSet:
                                  [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        } else {
            [wrongAns next];
            [buttons[i] setTitle:[[wrongAns stringForColumn:@"interpret"]
                                  stringByTrimmingCharactersInSet:
                                  [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
    }
    
    processCount++;
    [_ProgressLabel setStringValue:[NSString stringWithFormat:@"%d",processCount]];
    
    // Read the vocabulary
    NSSpeechSynthesizer *voice = [[NSSpeechSynthesizer alloc] init];
    [voice startSpeakingString:[randList stringForColumn:@"word"]];
}

- (IBAction)readCurrentWord:(id)sender {
    NSSpeechSynthesizer *voice = [[NSSpeechSynthesizer alloc] init];
    [voice startSpeakingString:[randList stringForColumn:@"word"]];
}


@end
