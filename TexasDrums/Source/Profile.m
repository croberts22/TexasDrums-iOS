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

+ (Profile *)createNewProfile:(NSDictionary *)dictionary {
    Profile *profile = [[[Profile alloc] init] autorelease];
    
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



@end