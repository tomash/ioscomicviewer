//
//  RBSComicPage.m
//  ComicReader
//
//  Created by Łukasz Adamczak on 5.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import "RBSComicPage.h"

@interface RBSComicPage ()
@property ZZArchiveEntry *archiveEntry;
@end

@implementation RBSComicPage

@synthesize archiveEntry = _archiveEntry;

- (id)initWithArchiveEntry:(ZZArchiveEntry *)entry
{
    self = [super init];
    if (self) {
        self.archiveEntry = entry;
    }
    return self;
}

+ (RBSComicPage *)pageWithArchiveEntry:(ZZArchiveEntry *)entry
{
    return [[RBSComicPage alloc] initWithArchiveEntry:entry];
}

#pragma mark MWPhoto protocol

- (UIImage *)underlyingImage
{
    return [UIImage imageWithData:self.archiveEntry.data];
}

- (void)loadUnderlyingImageAndNotify
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_LOADING_DID_END_NOTIFICATION
                                                        object:self];
}

- (void)unloadUnderlyingImage
{
}

@end
