//
//  NewsCell.h
//  TexasDrums
//
//  Created by Corey Roberts on 12/9/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell {
    UILabel *title_;
    UILabel *date_;
    UILabel *detail_;
    BOOL sticky_;
    BOOL memberPost_;
}

@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *date;
@property (nonatomic, retain) UILabel *detail;
@property (nonatomic, assign) BOOL sticky;
@property (nonatomic, assign) BOOL memberPost;

@end
