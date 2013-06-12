//
//  UIColor+HexString.m
//  ComicReader
//
//  Created by Łukasz Adamczak on 12.06.2013.
//  Copyright (c) 2013 Rebased s.c. All rights reserved.
//

#import "UIColor+HexString.h"

@implementation UIColor (HexString)

// Assumes input like "#00FF00" (#RRGGBB).
// http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
