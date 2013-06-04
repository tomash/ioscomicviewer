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
#import "RBSComic.h"

@interface RBSComic ()
@property ZZArchive *archive;
@property (readonly) NSArray *pages;
//- (NSArray *)filterPageEntries:(NSArray *)entries;
@end

@implementation RBSComic

@synthesize archive = _archive;
@synthesize pages = _pages;

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.archive = [ZZArchive archiveWithContentsOfURL:url];
    }
    return self;
}

- (NSArray *)pages
{
    if (_pages == nil) {
        // Pages are ZZArchiveEntry objects which represent image files
        _pages = [self.archive.entries select:^BOOL(ZZArchiveEntry *entry) {
            CFStringRef fileExtension = (__bridge CFStringRef) entry.fileName.pathExtension;
            CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
            return (UTTypeConformsTo(fileUTI, kUTTypeImage));
        }];
    }
    return _pages;
}

- (NSInteger)numPages
{
    return self.pages.count;
}

- (MWPhoto *)pageAtIndex:(NSInteger)index
{
    if (index >= self.numPages)
        return nil;
    
    ZZArchiveEntry *entry = self.pages[index];
    UIImage *pageImage = [UIImage imageWithData:entry.data];
    return [MWPhoto photoWithImage:pageImage];
}

#pragma mark Private methods

// Return only ZZArchiveEntries representing image files
- (NSArray *)filterPageEntries:(NSArray *)entries
{
    return [entries select:^BOOL(ZZArchiveEntry *entry) {
        CFStringRef fileExtension = (__bridge CFStringRef) entry.fileName.pathExtension;
        CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
        return (UTTypeConformsTo(fileUTI, kUTTypeImage));
    }];
}

@end
