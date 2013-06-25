//
//  UIImage+Thumbnails.m
//  ComicReader
//
//  Created by Łukasz Adamczak on 26.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import "UIImage+Thumbnails.h"

@implementation UIImage (Thumbnails)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToWidth:(CGFloat)width height:(CGFloat)height
{
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    
    CGFloat scaleFactor;
    
    if (oldWidth > oldHeight) {
        scaleFactor = width / oldWidth;
    } else {
        scaleFactor = height / oldHeight;
    }
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize size = CGSizeMake(newWidth, newHeight);
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
    }
    [image drawInRect:CGRectMake((width - newWidth) / 2, (height - newHeight) / 2, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
