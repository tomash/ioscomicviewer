//
//  RBSComicPage.m
//  ComicReader
//
//  Created by Łukasz Adamczak on 5.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import "RBSFrame.h"
#import "RBSScreen.h"

CGRect rectFromRelativeAreaAttribute(NSString *attributeString)
{
    NSArray *coordStrings = [attributeString componentsSeparatedByString:@" "];

    double x = [coordStrings[0] doubleValue];
    double y = [coordStrings[1] doubleValue];
    double w = [coordStrings[2] doubleValue];
    double h = [coordStrings[3] doubleValue];
    
    return CGRectMake(x, y, w, h);
}

NSArray *parseFramesMetadata(NSArray *framesMetadata)
{
    return [framesMetadata map:^id(RXMLElement *element) {
        CGRect rect = rectFromRelativeAreaAttribute([element attribute:@"relativeArea"]);
        return [[RBSFrame alloc] initWithRect:rect];
    }];
}

@interface RBSScreen ()
@property ZZArchiveEntry *archiveEntry;
@property RXMLElement *metadata;
@end

@implementation RBSScreen

@synthesize frames = _frames;
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

- (NSArray *)frames
{
    if (_frames == nil) {
        _frames = parseFramesMetadata([self.metadata children:@"frame"]);
    }
    return _frames;
}

- (NSUInteger)numFrames
{
    return self.frames.count;
}

- (NSInteger)indexOfFrameAtPoint:(CGPoint)point
{
    for (int i = 0; i < self.numFrames; i++) {
        RBSFrame *frame = self.frames[i];
        if (CGRectContainsPoint(frame.rect, point)) return i;
    }
    return -1;
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
