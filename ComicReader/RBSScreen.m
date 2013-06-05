//
//  RBSComicPage.m
//  ComicReader
//
//  Created by Łukasz Adamczak on 5.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import "RBSScreen.h"

@interface RBSScreen ()
@property ZZArchiveEntry *archiveEntry;
@property RXMLElement *metadata;
@end

@implementation RBSScreen

@synthesize paneRects = _paneRects;
@synthesize archiveEntry = _archiveEntry;

- (id)initWithArchiveEntry:(ZZArchiveEntry *)entry
{
    return [self initWithArchiveEntry:entry metadata:nil];
}

- (id)initWithArchiveEntry:(ZZArchiveEntry *)entry metadata:(id)metadata
{
    self = [super init];
    if (self) {
        self.archiveEntry = entry;
        self.metadata = metadata;
    }
    return self;
}

+ (RBSScreen *)screenWithArchiveEntry:(ZZArchiveEntry *)entry
{
    return [[RBSScreen alloc] initWithArchiveEntry:entry];
}

+ (id)screenWithArchiveEntry:(ZZArchiveEntry *)entry metadata:(RXMLElement *)metadata
{
    return [[RBSScreen alloc] initWithArchiveEntry:entry metadata:metadata];
}

// TODO: Replace dummy data with reading from comic.xml
- (CGRect *)paneRects
{
    if (_paneRects == NULL) {
        NSArray *frames = [self.metadata children:@"frame"];
        CGRect *rects = malloc(frames.count * sizeof(CGRect));
        
        for (int i = 0; i < frames.count; i++) {
            RXMLElement *frame = frames[i];
            
            NSArray *coordStrings = [[frame attribute:@"relativeArea"] componentsSeparatedByString:@" "];
            double x = [coordStrings[0] doubleValue];
            double y = [coordStrings[1] doubleValue];
            double w = [coordStrings[2] doubleValue];
            double h = [coordStrings[3] doubleValue];
            
            rects[i] = CGRectMake(x, y, w, h);
        }
        
        _paneRects = rects;
    }
    return _paneRects;
}

- (CGRect)paneAtPoint:(CGPoint)point
{
    // FIXME: self.paneRects can be NULL
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
