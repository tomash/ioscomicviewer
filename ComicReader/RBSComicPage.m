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

@synthesize paneRects = _paneRects;
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

// TODO: Replace dummy data with reading from comic.xml
- (CGRect *)paneRects
{
    if (_paneRects == NULL) {
        _paneRects = malloc(3 * sizeof(CGRect));
        _paneRects[0] = CGRectMake(0.1, 0.1, 0.8, 0.2);
        _paneRects[1] = CGRectMake(0.1, 0.4, 0.3, 0.3);
        _paneRects[2] = CGRectMake(0.5, 0.4, 0.4, 0.3);
    }
    return _paneRects;
}

- (CGRect)paneAtPoint:(CGPoint)point
{
    for (int i = 0; i < sizeof(self.paneRects); i++) {
        CGRect rect = self.paneRects[i];
        if (CGRectContainsPoint(rect, point)) {
            NSLog(@"Found rect: %@", NSStringFromCGRect(rect));
            return rect;
        }
    }
    
    return CGRectZero;
}

- (void)dealloc
{
    free(_paneRects);
}

#pragma mark MWPhoto protocol

- (UIImage *)underlyingImage
{
    // TODO: This is not instant, use loadUnderlyingImageAndNotify for async load
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
