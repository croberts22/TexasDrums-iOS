//
//  UIColor+TexasDrums.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/3/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "UIColor+TexasDrums.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation UIColor (TexasDrums)

+ (UIColor *)TexasDrumsOrangeColor {
    return UIColorFromRGB(0xFF792A);
}

+ (UIColor *)TexasDrumsGrayColor {
    return [UIColor lightGrayColor];
}

@end
