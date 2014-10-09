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
    // Pop up an modal Alert
    // Ask the user to select the amount of words to review
    
    NSAlert *scaleAlert = [NSAlert alertWithMessageText:@"Set the Scale"
                                     defaultButton:@"Set"
                                   alternateButton:@"Quit"
                                       otherButton:nil
                         informativeTextWithFormat:@"Pleasd input the number of words you want to review"];
    
    NSTextField *ipTextField = [[NSTextField alloc]init];
    ipTextField.backgroundColor = [NSColor whiteColor];
    ipTextField.frame = CGRectMake(0, 0, 250, 23);
    [scaleAlert setAccessoryView:ipTextField];
    
    while (true) {
        if ([scaleAlert runModal] == NSAlertAlternateReturn) {
            exit(1);
        } else {
            testScale = [[ipTextField stringValue] intValue];
            if (testScale > 0) {
                [_scaleLabel setStringValue:[NSString stringWithFormat:@"%d", testScale]];
                break;
            }
        }
    }
    
    // Initialize
    resultWindowController = [[ResultWindowController alloc] init];
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

#pragma - IBActions -

- (IBAction)answerSelected:(id)sender {
    if ([sender tag] == correctIndex) {
        correctCount++;
    } else {
        NSDictionary * thisWord = [[NSDictionary alloc]
                                            initWithObjectsAndKeys:
                                            [randList stringForColumn:@"interpret"], @"interpret",
                                            [randList stringForColumn:@"word"], @"word",
                                            nil];
        if ([sender tag] == PASS_BUTTON_TAG) {
            passCount++;
            [resultWindowController.incorrectWords addObject:thisWord];
        } else {
            [resultWindowController.passWords addObject:thisWord];
        }
    }
    
    
    if (processCount < testScale) {
        [self loadNextWord];
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Finished!"
                                         defaultButton:@"OK"
                                       alternateButton:@"Show Details"
                                           otherButton:nil
                             informativeTextWithFormat:@"%d Correct, %d Passes", correctCount, passCount];
        if ([alert runModal] == NSAlertAlternateReturn) {
            [[resultWindowController initWithWindowNibName:@"ResultWindow"] window];
        }
    }
}

- (IBAction)readCurrentWord:(id)sender {
    NSSpeechSynthesizer *voice = [[NSSpeechSynthesizer alloc] init];
    [voice startSpeakingString:[randList stringForColumn:@"word"]];
}

#pragma - Supplementary Methods for IBActions -

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
@end
