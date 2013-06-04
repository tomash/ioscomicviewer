//
//  RBSViewController.m
//  ComicReader
//
//  Created by Łukasz Adamczak on 4.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import "RBSViewController.h"

@implementation RBSViewController

@synthesize photos = _photos;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSMutableArray *photos = [NSMutableArray array];
    MWPhoto *page;
    
    page = [MWPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"006" ofType:@"png"]];
    [photos addObject:page];
    page = [MWPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"007" ofType:@"png"]];
    [photos addObject:page];
    
    self.photos = photos;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openSampleComic:(id)sender
{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return 2;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

@end
