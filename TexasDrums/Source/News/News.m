//
//  News.m
//  TexasDrums
//
//  Created by Corey Roberts on 4/4/13.
//  Copyright (c) 2013 Corey Roberts. All rights reserved.
//

#import "News.h"


@implementation News

@dynamic title;
@dynamic content;
@dynamic subtitle;
@dynamic author;
@dynamic datePosted;
@dynamic dateEdited;
@dynamic timestamp;
@dynamic memberPost;
@dynamic sticky;

- (void)awakeFromInsert {
    self.title = @"";
    self.content = @"";
    self.subtitle = @"";
    self.author = @"";
    self.datePosted = nil;
    self.dateEdited = nil;
    self.timestamp = @(0);
    self.memberPost = @(0);
    self.sticky = @(0);
}

@end
