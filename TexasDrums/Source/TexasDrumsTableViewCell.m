//
//  TexasDrumsTableViewCell.m
//  TexasDrums
//
//  Created by Corey Roberts on 4/16/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "TexasDrumsTableViewCell.h"
#import "UIFont+TexasDrums.h"

@implementation TexasDrumsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if(style == UITableViewCellStyleSubtitle){
            self.backgroundColor = [UIColor clearColor];
            self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uitableviewselection-orange-60.png"]] autorelease];
            
            self.textLabel.numberOfLines = 1;
            self.textLabel.font = [UIFont TexasDrumsFontOfSize:14];
            self.textLabel.textColor = [UIColor lightGrayColor];
            
            self.detailTextLabel.numberOfLines = 2;
            self.detailTextLabel.font = [UIFont TexasDrumsFontOfSize:12];
            self.detailTextLabel.textColor = [UIColor grayColor];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
