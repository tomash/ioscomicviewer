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

@interface RBSViewController : UIViewController <MWPhotoBrowserDelegate>

@property RBSComic *currentComic;

@end
