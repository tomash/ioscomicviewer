//
//  RBSComic.m
//  ComicReader
//
//  Created by Łukasz Adamczak on 4.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import <MWPhotoBrowser.h>
#import <zipzap.h>
#import <NSArray+BlocksKit.h>
#import <RXMLElement.h>
#import "RBSScreen.h"
#import "RBSComic.h"

@interface RBSComic ()
@property ZZArchive *archive;
@property RXMLElement *metadata;
@property (readonly) NSArray *screens;

- (RXMLElement *)loadMetadata;
@end

@implementation RBSComic

@synthesize archive = _archive;
@synthesize metadata = _metadata;
@synthesize screens = _screens;

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.archive = [ZZArchive archiveWithContentsOfURL:url];
        self.metadata = [self loadMetadata];
    }
    return self;
}

- (NSArray *)screens
{
    if (_screens == nil) {
        NSMutableArray *screens = [NSMutableArray array];
        
        // 1. [select] only ZZArchiveEntries with images
        NSArray *entries = [self.archive.entries select:^BOOL(ZZArchiveEntry *entry) {
            CFStringRef fileExtension = (__bridge CFStringRef) entry.fileName.pathExtension;
            CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
            return (UTTypeConformsTo(fileUTI, kUTTypeImage));
        }];
        
        // 2. Find "screen" XML elements
        NSArray *elements = [self.metadata children:@"screen"];
        
        // 3. Match archive entries & XML elements
        for (int i = 0; i < elements.count; i++) {
            ZZArchiveEntry *entry = entries[i];
            RXMLElement *metadata = elements[i];
            
            [screens addObject:[RBSScreen screenWithArchiveEntry:entry metadata:metadata]];
        }
        
        _screens = screens;
    }
    return _screens;
}

- (NSString *)title
{
    if (self.metadata) {
        return [self.metadata attribute:@"title"];
    }
    else {
        return self.archive.URL.lastPathComponent;
    }
}

- (NSInteger)numScreens
{
    return self.screens.count;
}

- (RBSScreen *)screenAtIndex:(NSInteger)index
{
    if (index >= self.numScreens)
        return nil;
    return self.screens[index];
}

#pragma mark Private methods

- (RXMLElement *)loadMetadata
{
    ZZArchiveEntry *entry = [[self.archive.entries select:^BOOL(ZZArchiveEntry *e) {
        return [e.fileName isEqualToString:@"comic.xml"];
    }] lastObject];
    
    if (entry == nil) {
        return nil;
    }
    else {
        return [RXMLElement elementFromXMLData:entry.data];
    }
}

@end
