//
//  RBSComic.m
//  ComicReader
//
//  Created by Łukasz Adamczak on 4.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import "RBSComic.h"

@implementation RBSComic

@synthesize archive = _archive;
@synthesize screens = _screens;

- (NSInteger)numScreens
{
    return self.screens.count;
}

- (RBSScreen *)screenAtIndex:(NSInteger)index
{
    if (index >= self.numScreens)
        return nil;
    return self.screens[index];
}

@end
