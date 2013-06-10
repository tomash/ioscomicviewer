//
//  RBSComic+Loading.m
//  ComicReader
//
//  Created by Łukasz Adamczak on 10.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>

#import "RBSScreen.h"
#import "RBSComic+Loading.h"

RXMLElement *loadMetadata(ZZArchive *archive)
{
    ZZArchiveEntry *entry = [[archive.entries select:^BOOL(ZZArchiveEntry *e) {
        return [e.fileName isEqualToString:@"comic.xml"];
    }] lastObject];
    
    if (entry == nil) {
        return nil;
    }
    else {
        return [RXMLElement elementFromXMLData:entry.data];
    }
}

NSArray *loadScreens(ZZArchive *archive)
{
    // 1. [select] only ZZArchiveEntries with images
    NSArray *entries = [archive.entries select:^BOOL(ZZArchiveEntry *entry) {
        CFStringRef fileExtension = (__bridge CFStringRef) entry.fileName.pathExtension;
        CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
        return (UTTypeConformsTo(fileUTI, kUTTypeImage));
    }];
    
    RXMLElement *metadata = loadMetadata(archive);

    if (metadata != nil) {
        // 2. Find "screen" XML elements
        NSMutableArray *screens = [NSMutableArray array];
        NSArray *elements = [metadata children:@"screen"];
        
        // 3. Match archive entries & XML elements
        for (int i = 0; i < elements.count; i++) {
            ZZArchiveEntry *entry = entries[i];
            RXMLElement *metadata = elements[i];
            
            [screens addObject:[RBSScreen screenWithArchiveEntry:entry metadata:metadata]];
        }
        
        return screens;
    }
    else {
        return [entries map:^id(ZZArchiveEntry *entry) {
            return [RBSScreen screenWithArchiveEntry:entry];
        }];
    }
}

@implementation RBSComic (Loading)

+ (RBSComic *)comicWithURL:(NSURL *)url
{
    // TODO: Check if archive opened successfully
    ZZArchive *archive = [ZZArchive archiveWithContentsOfURL:url];
    
    RBSComic *comic = [[RBSComic alloc] init];
    comic.screens = loadScreens(archive);
    
    // NOTE: A reference to ZZArchive must be preserved
    comic.archive = archive;
    
    return comic;
}

@end
