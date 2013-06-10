//
//  RBSComic.h
//  ComicReader
//
//  Created by Łukasz Adamczak on 4.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZZArchive, RBSScreen;

@interface RBSComic : NSObject

@property ZZArchive *archive;
@property NSArray *screens;
@property (readonly) NSInteger numScreens;

- (RBSScreen *)screenAtIndex:(NSInteger)index;

@end
