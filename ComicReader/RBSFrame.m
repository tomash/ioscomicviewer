//
//  RBSFrame.m
//  ComicReader
//
//  Created by Łukasz Adamczak on 6.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import "RBSFrame.h"

@implementation RBSFrame

@synthesize rect = _rect;

- (id)initWithRect:(CGRect)rect
{
    self = [super init];
    if (self) {
        _rect = rect;
    }
    return self;
}

@end
