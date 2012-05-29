//
//  UserProfile.m
//  TexasDrums
//
//  Created by Corey Roberts on 5/21/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile

@synthesize firstname, lastname, username, hash;
@synthesize section, years, status;
@synthesize sl, instructor, admin;
@synthesize phonenumber, email, birthday, valid, lastlogin, paid;

static UserProfile *defaultUserProfile;

+ (void)initialize
{
    static BOOL initialized = NO;
    @synchronized(self) {
        if(!initialized)
        {
            initialized = YES;
            defaultUserProfile = [[UserProfile alloc] init];
        }
    }
}

@end
