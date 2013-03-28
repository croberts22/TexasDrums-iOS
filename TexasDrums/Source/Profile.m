//
//  Profile.m
//  TexasDrums
//
//  Created by Corey Roberts on 8/9/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "Profile.h"

@implementation Profile

@synthesize firstname, lastname, username, password, section, years, status, sl, instructor, admin, phonenumber, email, birthday, valid, lastlogin, paid, alphabet_last, alphabet_first, user_id;

#pragma mark - Memory Management

- (id)init {
    if( (self = [super init])) {
        self.firstname = @"";
        self.lastname = @"";
        self.username = @"";
        self.password = @"";
        self.section = @"";
        self.years = @"";
        self.status = @"";
        self.sl = NO;
        self.instructor = NO;
        self.admin = NO;
        self.phonenumber = @"";
        self.email = @"";
        self.birthday = @"";
        self.valid = NO;
        self.lastlogin = @"";
        self.paid = NO;
        self.alphabet_first = @"";
        self.alphabet_last = @"";
        self.user_id = -1;
    }
    return self;
}

#pragma mark - Class Methods

+ (Profile *)createNewProfile:(NSDictionary *)dictionary {
    Profile *profile = [[Profile alloc] init];
    
    profile.firstname = [dictionary objectForKey:@"firstname"];
    profile.lastname = [dictionary objectForKey:@"lastname"];
    profile.username = [dictionary objectForKey:@"username"];
    profile.section = [dictionary objectForKey:@"section"];
    profile.years = [dictionary objectForKey:@"years"];
    profile.status = [dictionary objectForKey:@"status"];
    
    profile.birthday = [dictionary objectForKey:@"birthday"];
    profile.email = [dictionary objectForKey:@"email"];
    profile.phonenumber = [dictionary objectForKey:@"phonenumber"];
    profile.sl = [[dictionary objectForKey:@"sl"] intValue];
    profile.valid = [[dictionary objectForKey:@"valid"] boolValue];
    profile.paid = [[dictionary objectForKey:@"paid"] boolValue];
    
    profile.alphabet_first = [NSString stringWithFormat:@"%c", [profile.firstname characterAtIndex:0]];
    profile.alphabet_last = [NSString stringWithFormat:@"%c", [profile.lastname characterAtIndex:0]];
    
    return profile;
}

#pragma mark - Instance Methods

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstname, self.lastname];
}



@end