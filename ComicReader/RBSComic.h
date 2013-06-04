//
//  RBSComic.h
//  ComicReader
//
//  Created by Łukasz Adamczak on 4.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MWPhoto;

@interface RBSComic : NSObject

- (id)initWithURL:(NSURL *)url;
- (NSInteger)numPages;
- (MWPhoto *)pageAtIndex:(NSInteger)index;

@end
