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

#define kAcceptedExtensionsPattern @"cbz|acv"

@interface RBSIndexController ()
@property (readonly) NSArray *comicFiles;
- (void)reloadComicFiles;
@end

@implementation RBSIndexController

@synthesize comicFiles = _comicFiles;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Make sure index is reloaded when returning to foreground
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(reloadComicFiles)
                                                 name: UIApplicationDidBecomeActiveNotification
                                               object: nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadComicFiles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadComicFiles
{
    _comicFiles = nil;
    [self.tableView reloadData];
}

#pragma mark Properties

- (NSArray *)comicFiles
{
    if (_comicFiles == nil) {
        NSString *documentsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSArray *allFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDir error:nil];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kAcceptedExtensionsPattern options:NSRegularExpressionCaseInsensitive error:nil];

        _comicFiles = [[allFiles select:^BOOL(NSString *filename) {
            NSUInteger numMatches = [regex numberOfMatchesInString:filename.pathExtension options:0 range:NSMakeRange(0, filename.pathExtension.length)];
            return numMatches > 0;
        }] map:^id(NSString *filename) {
            return [documentsDir stringByAppendingPathComponent:filename];
        }];
    }
    return _comicFiles;
}

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
