//
//  AppDelegate.m
//  Example
//
//  Created by Daniel Weber on 9/28/14.
//  Copyright (c) 2014 Null Creature. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, assign) IBOutlet NCRAutocompleteTextView *textView;
@property (nonatomic, strong) NSMutableDictionary *imageDict;
@property (nonatomic, strong) NSArray *wordlist;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"wordlist" withExtension:@"txt"];
    NSString *countriesString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    self.wordlist = [countriesString componentsSeparatedByString:@"\n"];
    
    // Flag Icons by GoSquared (http://www.gosquared.com/)
    self.imageDict = [NSMutableDictionary dictionary];
    NSArray *imagePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"flags"];
    for (NSString *path in imagePaths) {
        self.imageDict[[[[path lastPathComponent] stringByDeletingPathExtension] stringByReplacingOccurrencesOfString:@"-" withString:@" "]] = [[NSImage alloc] initWithContentsOfFile:path];
    }
    
    self.textView.delegate = self;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (NSImage *)textView:(NSTextView *)textView imageForCompletion:(NSString *)word {
    NSImage *image = self.imageDict[word];
    if (image) {
        return image;
    }
    return self.imageDict[@"Unknown"];
}

- (NSArray *)textView:(NSTextView *)textView completions:(NSArray *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index {
    NSMutableArray *matches = [NSMutableArray array];
    for (NSString *string in self.wordlist) {
        if ([string rangeOfString:[[textView string] substringWithRange:charRange] options:NSAnchoredSearch|NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])].location != NSNotFound) {
            [matches addObject:string];
        }
    }
    [matches sortUsingSelector:@selector(compare:)];
    return matches;
}

@end
