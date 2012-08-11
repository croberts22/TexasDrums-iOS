//
//  UIView+TexasDrums.h
//  TexasDrums
//
//  Created by Corey Roberts on 7/27/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TexasDrums)

+ (UIView *)TexasDrumsGroupedTableHeaderViewWithTitle:(NSString *)title andAlignment:(UITextAlignment)alignment;
+ (UIView *)TexasDrumsAddressBookTableHeaderViewWithTitle:(NSString *)title;
+ (UIView *)TexasDrumsFAQTableHeaderViewWithTitle:(NSString *)title;
+ (UIView *)TexasDrumsVideoHeaderWithTitle:(NSString *)title;
+ (UIView *)TexasDrumsVersionFooter;
+ (UIView *)TexasDrumsCheckmarkAccessoryView;

@end
