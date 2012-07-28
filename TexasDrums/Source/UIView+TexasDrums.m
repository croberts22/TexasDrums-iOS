//
//  UIView+TexasDrums.m
//  TexasDrums
//
//  Created by Corey Roberts on 7/27/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "UIView+TexasDrums.h"

@implementation UIView (TexasDrums)

+ (UIView *)TexasDrumsGroupedTableHeaderViewWithTitle:(NSString *)title andAlignment:(UITextAlignment)alignment {
    UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, HEADER_HEIGHT)] autorelease];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 30)] autorelease];
    
    label.textAlignment = alignment;
    label.textColor = [UIColor TexasDrumsOrangeColor];
    label.font = [UIFont TexasDrumsBoldFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    label.shadowOffset = CGSizeMake(0, 1);

    label.text = title;
    
    [header addSubview:label];
    
    return header;
}

+ (UIView *)TexasDrumsAddressBookTableHeaderViewWithTitle:(NSString *)title {
    
    UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 25)] autorelease];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 25)] autorelease];
    
    header.backgroundColor = [UIColor blackColor];
    
    label.textAlignment = UITextAlignmentLeft;
    label.textColor = [UIColor TexasDrumsOrangeColor];
    label.font = [UIFont TexasDrumsBoldFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    label.shadowOffset = CGSizeMake(0, 1);
    
    label.text = title;
    
    [header addSubview:label];
    
    return header;
}

+ (UIView *)TexasDrumsFAQTableHeaderViewWithTitle:(NSString *)title {
    
    UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, STANDARD_HEADER_HEIGHT)] autorelease];
    UIImage *headerImage = [UIImage imageNamed:@"header.png"];
    UIImageView *headerImageView = [[[UIImageView alloc] initWithImage:headerImage] autorelease];
    headerImageView.frame = CGRectMake(0, 0, 320, 30);

    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 25)] autorelease];
    
    header.backgroundColor = [UIColor blackColor];
    
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor TexasDrumsOrangeColor];
    label.font = [UIFont TexasDrumsBoldFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    label.shadowOffset = CGSizeMake(0, 1);
    
    label.text = title;
    
    [header addSubview:headerImageView];
    [header addSubview:label];
    
    return header;
}

+ (UIView *)TexasDrumsVersionFooter {
    
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 10)] autorelease];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)] autorelease];
    
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont TexasDrumsBoldFontOfSize:14];
    label.backgroundColor = [UIColor clearColor];
    label.shadowOffset = CGSizeMake(0, 1);
    
    label.text =[NSString stringWithFormat:@"You're using version %@!", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]];
    
    [footer addSubview:label];
    
    return footer;
}

@end
