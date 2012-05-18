//
//  TexasDrumsGroupedTableViewCell.m
//  TexasDrums
//
//  Created by Corey Roberts on 4/16/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import "TexasDrumsGroupedTableViewCell.h"

@implementation TexasDrumsGroupedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = [UIColor lightGrayColor];
        self.textLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:18];
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell.png"]] autorelease];
        ((UIImageView *)self.backgroundView).image = [UIImage imageNamed:@"table_cell.png"];
        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell.png"]] autorelease];
        ((UIImageView *)self.selectedBackgroundView).image = [UIImage imageNamed:@"table_cell.png"];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
