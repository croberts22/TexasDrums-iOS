//
//  News.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/24/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "News.h"


@implementation News

@synthesize titleOfPost, post, author, time, timestamp, postDate, subtitle, memberPost, sticky;

- (id)init {
    if((self = [super init])) {
        self.titleOfPost = @"";
        self.post = @"";
        self.author = @"";
        self.time = @"";
        self.timestamp = -1;
        self.postDate = @"";
        self.subtitle = @"";
        self.memberPost = FALSE;
        self.sticky = FALSE;
    }
    
    return self;
}

+ (News *)createNewPost:(NSDictionary *)item {
    News *post = [[[News alloc] init] autorelease];
    
    post.post = [item objectForKey:@"content"];
    post.postDate = [item objectForKey:@"date"];
    post.author = [item objectForKey:@"firstname"];
    post.time = [item objectForKey:@"time"];
    post.timestamp = [[item objectForKey:@"timestamp"] intValue];
    post.titleOfPost = [item objectForKey:@"title"];
    post.memberPost = [[item objectForKey:@"membernews"] boolValue];
    post.sticky = [[item objectForKey:@"sticky"] boolValue];
    post.subtitle = [NSString extractHTML:post.post];
    post.subtitle = [NSString stripExcessEscapes:post.subtitle];
    
    return post;
}

@end
