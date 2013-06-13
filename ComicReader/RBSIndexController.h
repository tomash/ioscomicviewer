//
//  RBSViewController.h
//  ComicReader
//
//  Created by Łukasz Adamczak on 4.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MWPhotoBrowser.h>

@class RBSComic;

@interface RBSIndexController : UITableViewController <MWPhotoBrowserDelegate, UITableViewDataSource>

@property NSArray *comicFiles;
@property RBSComic *currentComic;

@end
