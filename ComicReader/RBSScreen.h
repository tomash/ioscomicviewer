//
//  RBSComicPage.h
//  ComicReader
//
//  Created by Łukasz Adamczak on 5.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MWPhotoProtocol.h>

@class RBSFrame;

@interface RBSScreen : NSObject <MWPhoto>

@property (readonly) NSArray *frames;
@property (readonly) NSUInteger numFrames;

+ (id)screenWithArchiveEntry:(ZZArchiveEntry *)entry;
+ (id)screenWithArchiveEntry:(ZZArchiveEntry *)entry metadata:(RXMLElement *)metadata;
- (id)initWithArchiveEntry:(ZZArchiveEntry *)entry;
- (id)initWithArchiveEntry:(ZZArchiveEntry *)entry metadata:(RXMLElement *)metadata;

- (NSInteger)indexOfFrameAtPoint:(CGPoint)point;

@end
