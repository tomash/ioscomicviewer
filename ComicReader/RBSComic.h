//
//  RBSComic.h
//  ComicReader
//
//  Created by Łukasz Adamczak on 4.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RBSComicPage;

@interface RBSComic : NSObject

@property (readonly) NSString *title;
@property (readonly) NSInteger numPages;

- (id)initWithURL:(NSURL *)url;
- (RBSComicPage *)pageAtIndex:(NSInteger)index;

@end
