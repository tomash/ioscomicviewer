//
//  RBSViewController.m
//  ComicReader
//
//  Created by Łukasz Adamczak on 4.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import <zipzap.h>
#import <NSArray+BlocksKit.h>
#import "RBSComic.h"
#import "RBSComic+Loading.h"
#import "RBSScreen.h"
#import "RBSIndexController.h"

@implementation RBSIndexController

@synthesize comicFiles = _comicFiles;

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
    return self.comicFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComicCell"];

    NSString *filename = self.comicFiles[indexPath.row];
    cell.textLabel.text = filename.lastPathComponent;
    cell.imageView.image = [UIImage imageNamed:@"Default.png"];

    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *comicURL = [NSURL fileURLWithPath:self.comicFiles[indexPath.row]];
    self.currentComic = [RBSComic comicWithURL:comicURL];
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    [self.navigationController pushViewController:browser animated:YES];
}

@end
