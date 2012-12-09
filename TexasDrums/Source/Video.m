//
//  Video.m
//  TexasDrums
//
//  Created by Corey Roberts on 4/13/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "Video.h"

@interface Video()

- (NSURL *)createThumbnailURL;

@end

@implementation Video

@synthesize videoTitle, type, link, videoID, description, videoYear, videoDate, time, timestamp, valid, thumbnail;

#pragma mark - Memory Management

- (id)init {
    if((self = [super init])) {
        self.videoTitle = @"";
        self.type = @"";
        self.link = @"";
        self.videoID = @"";
        self.description = @"";
        self.videoYear = @"";
        self.videoDate = @"";
        self.time = @"";
        self.thumbnail = nil;
        self.timestamp = -1;
        self.valid = NO;
    }
    
    return self;
}

- (void)dealloc {
    [videoTitle release], videoTitle = nil;
    [type release], type = nil;
    [link release], link = nil;
    [videoID release], videoID = nil;
    [description release], description = nil;
    [videoYear release], videoYear = nil;
    [videoDate release], videoDate = nil;
    [time release], time = nil;
    [thumbnail release], thumbnail = nil;
    
    [super dealloc];
}

#pragma mark - Class Methods

+ (Video *)createNewVideo:(NSDictionary *)item {
    Video *video = [[[Video alloc] init] autorelease];
    
    video.videoTitle = [item objectForKey:@"title"];
    video.type = [item objectForKey:@"videotype"];
    video.link = [item objectForKey:@"link"];
    video.videoID = [item objectForKey:@"videoid"];
    video.description = [item objectForKey:@"description"];
    video.description = [NSString extractHTML:video.description];
    video.description = [NSString stripExcessEscapes:video.description];
    video.videoYear = [item objectForKey:@"year"];
    video.videoDate = [item objectForKey:@"date"];
    video.time = [item objectForKey:@"time"];
    video.timestamp = [[item objectForKey:@"timestamp"] intValue];
    video.valid = [[item objectForKey:@"valid"] boolValue];
    video.thumbnail = [video createThumbnailURL];
    
    return video;
}

#pragma mark - Instance Methods

- (NSURL *)createThumbnailURL {
    NSString *string = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg", self.videoID];
    NSURL *url = [[[NSURL alloc] initWithString:string] autorelease];

    return url;
}



@end
