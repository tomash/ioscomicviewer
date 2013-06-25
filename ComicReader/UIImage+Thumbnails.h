//
//  UIImage+Thumbnails.h
//  ComicReader
//
//  Created by Łukasz Adamczak on 26.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Thumbnails)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToWidth:(CGFloat)width height:(CGFloat)height;

@end
