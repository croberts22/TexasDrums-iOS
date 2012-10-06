//
//  StaffMember.m
//  TexasDrums
//
//  Created by Corey Roberts on 1/19/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "StaffMember.h"

@implementation StaffMember

@synthesize first, last, fullname, instrument, year, bio, email, sortfield, image_url;

#pragma mark - Memory Management

- (id)init {
    if((self = [super init])) {
        self.first = @"";
        self.last = @"";
        self.fullname = @"";
        self.instrument = @"";
        self.year = @"";
        self.bio = @"";
        self.image_url = @"";
        self.email = @"";
        self.sortfield = -1;
    }
    
    return self;
}

- (void)dealloc {
    [first release], first = nil;
    [last release], last = nil;
    [fullname release], fullname = nil;
    [instrument release], instrument = nil;
    [year release], year = nil;
    [bio release], bio = nil;
    [image_url release], image_url = nil;
    [email release], email = nil;
    [super dealloc];
}

#pragma mark - Class Methods

+ (StaffMember *)createNewStaffMember:(NSDictionary *)item {
    StaffMember *member = [[[StaffMember alloc] init] autorelease];
    member.first = [item objectForKey:@"firstname"];
    member.last = [item objectForKey:@"lastname"];
    member.fullname = [NSString stringWithFormat:@"%@ %@", member.first, member.last];
    member.instrument = [item objectForKey:@"section"];
    member.year = [item objectForKey:@"year"];
    member.bio = [item objectForKey:@"bio"];
    member.image_url = [item objectForKey:@"image"];
    member.email = [item objectForKey:@"email"];
    member.sortfield = [[item objectForKey:@"sortfield"] intValue];
    
    return member;
}


@end
