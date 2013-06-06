//
//  RBSFrame.h
//  ComicReader
//
//  Created by Łukasz Adamczak on 6.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBSFrame : NSObject

@property (readonly) CGRect rect;

- (id)initWithRect:(CGRect)rect;

@end
