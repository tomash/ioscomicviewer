//
//  RBSViewController.m
//  ComicReader
//
//  Created by Łukasz Adamczak on 4.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import <zipzap.h>
#import "RBSComic.h"
#import "RBSViewController.h"

@implementation RBSViewController

@synthesize currentComic = _currentComic;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // TODO: Retrieve from the documents directory
    NSURL *comicUrl = [[NSBundle mainBundle] URLForResource:@"Sample Comic" withExtension:@"cbz"];
    
    self.currentComic = [[RBSComic alloc] initWithURL:comicUrl];
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
    return self.currentComic.numPages;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    return [self.currentComic pageAtIndex:index];
}

@end
