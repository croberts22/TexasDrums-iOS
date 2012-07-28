//
//  UIFont+TexasDrums.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/13/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "UIFont+TexasDrums.h"

@implementation UIFont (TexasDrums) 

+ (UIFont *)TexasDrumsFontOfSize:(int)size {
    return [UIFont fontWithName:@"Georgia" size:size];
}

+ (UIFont *)TexasDrumsBoldFontOfSize:(int)size {
    return [UIFont fontWithName:@"Georgia-Bold" size:size];
}

+ (UIFont *)TexasDrumsItalicFontOfSize:(int)size {
    return [UIFont fontWithName:@"Georgia-Italic" size:size];
}

@end
