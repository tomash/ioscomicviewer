//
//  RBSViewController.m
//  ComicReader
//
//  Created by Łukasz Adamczak on 4.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import <zipzap.h>
#import <NSArray+BlocksKit.h>
#import "UIImage+Thumbnails.h"
#import "RBSComic.h"
#import "RBSComic+Loading.h"
#import "RBSScreen.h"
#import "RBSIndexController.h"

@implementation RBSIndexController

@synthesize comics = _comics;

#pragma mark MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.currentComic.screens.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index >= self.currentComic.screens.count)
        return nil;
    return self.currentComic.screens[index];
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser shouldAllowZoomMode:(RBSZoomMode)zoomMode
{
    return (zoomMode != RBSZoomModeFrame) || self.currentComic.hasFrameMetadata;
}

- (UIColor *)backgroundColorForPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.currentComic.backgroundColor;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComicCell"];

    RBSComic *comic = self.comics[indexPath.row];
    
    cell.textLabel.text = comic.title;
    cell.detailTextLabel.text = comic.author;
    
    UIImage *coverImage = [comic.screens[0] underlyingImage];
    cell.imageView.image = [UIImage imageWithImage:coverImage scaledToWidth:70.0f height:70.0f];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentComic = self.comics[indexPath.row];
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = YES;
    browser.zoomMode = RBSZoomModePage;
    [self.navigationController pushViewController:browser animated:YES];
}

@end
