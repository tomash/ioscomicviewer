//
//  UIColor+HexString.h
//  ComicReader
//
//  Created by Łukasz Adamczak on 12.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)

+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end
