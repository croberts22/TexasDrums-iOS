//
//  RosterMember.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/24/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "RosterMember.h"


@implementation RosterMember

@synthesize firstname, nickname, lastname, fullname;
@synthesize instrument, classification, year, amajor;
@synthesize hometown, quote, position, phone, email, valid;

#pragma mark - Memory Management

- (id)init {
    if((self = [super init])) {
        self.firstname = @"";
        self.nickname = @"";
        self.lastname = @"";
        self.fullname = @"";
        self.instrument = @"";
        self.classification = @"";
        self.year = @"";
        self.amajor = @"";
        self.hometown = @"";
        self.quote = @"";
        self.position = -1;
        self.phone = @"";
        self.email = @"";
        self.valid = 0;
    }
    
    return self;
}

#pragma mark - Class Methods

+ (RosterMember *)createNewRosterMember:(NSDictionary *)item {
    RosterMember *member = [[RosterMember alloc] init];
    
    member.firstname = [item objectForKey:@"firstname"];
    member.nickname = [item objectForKey:@"nickname"];
    member.lastname = [item objectForKey:@"lastname"];
    member.fullname = [NSString stringWithFormat:@"%@ %@", member.firstname, member.lastname];
    member.instrument = [item objectForKey:@"instrument"];
    member.classification = [item objectForKey:@"classification"];
    member.year = [item objectForKey:@"year"];
    member.amajor = [item objectForKey:@"major"];
    member.hometown = [item objectForKey:@"hometown"];
    member.quote = [item objectForKey:@"quote"];
    member.quote = [NSString convertHTML:member.quote];
    member.position = [[item objectForKey:@"position"] intValue];
    member.phone = [item objectForKey:@"phone"];
    member.phone = [NSString parsePhoneNumber:member.phone];
    member.email = [item objectForKey:@"email"];
    member.valid = [[item objectForKey:@"valid"] intValue];
    
    if([member.email length] == 0){
        member.email = @"n/a";
    }
    
    return member;
}

@end
