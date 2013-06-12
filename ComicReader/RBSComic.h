//
//  RBSComic.h
//  ComicReader
//
//  Created by Łukasz Adamczak on 4.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RBSScreen;

@interface RBSComic : NSObject

@property ZZArchive *archive;
@property NSArray *screens;
@property BOOL hasFrameMetadata;

@end
