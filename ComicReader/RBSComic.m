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
#import "RBSComicPage.h"
#import "RBSComic.h"

@interface RBSComic ()
@property ZZArchive *archive;
@property RXMLElement *metadata;
@property (readonly) NSArray *pages;

- (RXMLElement *)loadMetadata;
@end

@implementation RBSComic

@synthesize archive = _archive;
@synthesize metadata = _metadata;
@synthesize pages = _pages;

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.archive = [ZZArchive archiveWithContentsOfURL:url];
        self.metadata = [self loadMetadata];
    }
    return self;
}

- (NSArray *)pages
{
    if (_pages == nil) {
        // 1. [select] only ZZArchiveEntries with images
        // 2. [map] to RBSComicPage instances
        _pages = [[self.archive.entries select:^BOOL(ZZArchiveEntry *entry) {
            CFStringRef fileExtension = (__bridge CFStringRef) entry.fileName.pathExtension;
            CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
            return (UTTypeConformsTo(fileUTI, kUTTypeImage));
        }] map:^id(ZZArchiveEntry *entry) {
            return [RBSComicPage pageWithArchiveEntry:entry];
        }];
    }
    return _pages;
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

- (NSInteger)numPages
{
    return self.pages.count;
}

- (RBSComicPage *)pageAtIndex:(NSInteger)index
{
    if (index >= self.numPages)
        return nil;
    return self.pages[index];
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
