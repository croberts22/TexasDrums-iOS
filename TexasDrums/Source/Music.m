//
//  Music.m
//  TexasDrums
//
//  Created by Corey Roberts on 3/30/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "Music.h"

@implementation Music 

@synthesize filename, location, instrument, year, filetype, status, valid;

#pragma mark - Memory Management

- (id)init {
    if ( (self = [super init]) ) {
        self.filename = @"";
        self.location = @"";
        self.instrument = @"";
        self.year = -1;
        self.filetype = @"";
        self.status = @"";
        self.valid = NO;
    }
    
    return self;
}

- (void)dealloc {
    [filename release], filename = nil;
    [location release], location = nil;
    [instrument release], instrument = nil;
    [filetype release], filetype = nil;
    [status release], status = nil;
    [super dealloc];
}

#pragma mark - Class Methods

+ (Music *)createNewMusic:(NSDictionary *)item {
    Music *music = [[[Music alloc] init] autorelease];
    
    music.filename = [item objectForKey:@"name"];
    music.location = [[item objectForKey:@"location"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    music.instrument = [item objectForKey:@"instrument"];
    music.year = [[item objectForKey:@"year"] intValue];
    music.filetype = [item objectForKey:@"filetype"];
    music.status = [item objectForKey:@"status"];
    music.valid = [[item objectForKey:@"valid"] boolValue];
    
    return music;
}

@end
