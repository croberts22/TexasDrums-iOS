//
//  UILabel+TexasDrums.m
//  TexasDrums
//
//  Created by Corey Roberts on 7/28/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "UILabel+TexasDrums.h"

@implementation UILabel (TexasDrums)

+ (UILabel *)TexasDrumsNavigationBar; {
    UILabel *navigationBarView = [[UILabel alloc] initWithFrame:CGRectZero];
    navigationBarView.backgroundColor = [UIColor clearColor];
    navigationBarView.font = [UIFont TexasDrumsBoldFontOfSize:20];
    navigationBarView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    navigationBarView.textColor = [UIColor whiteColor];
    
    return navigationBarView;
}

@end
