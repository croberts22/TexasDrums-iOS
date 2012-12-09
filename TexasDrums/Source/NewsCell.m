//
//  NewsCell.m
//  TexasDrums
//
//  Created by Corey Roberts on 12/9/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

@synthesize title = title_;
@synthesize date = date_;
@synthesize detail = detail_;
@synthesize sticky = sticky_;
@synthesize memberPost = memberPost_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x + 10,
                                                               self.frame.origin.y + 10,
                                                               self.frame.size.width,
                                                               20)];
        self.title.font = [UIFont TexasDrumsBoldFontOfSize:14];
        [self addSubview:title_];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
