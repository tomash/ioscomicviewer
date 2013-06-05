//
//  RBSComicPage.h
//  ComicReader
//
//  Created by Łukasz Adamczak on 5.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MWPhotoProtocol.h>

@interface RBSScreen : NSObject <MWPhoto>

@property (readonly) CGRect *paneRects;

+ (id)screenWithArchiveEntry:(ZZArchiveEntry *)entry;
+ (id)screenWithArchiveEntry:(ZZArchiveEntry *)entry metadata:(RXMLElement *)metadata;
- (id)initWithArchiveEntry:(ZZArchiveEntry *)entry;
- (id)initWithArchiveEntry:(ZZArchiveEntry *)entry metadata:(RXMLElement *)metadata;

- (CGRect)paneAtPoint:(CGPoint)point;

@end
