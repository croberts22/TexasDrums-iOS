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

static UserProfile *sharedInstance = nil;

+ (UserProfile *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:nil] init];
    }
    
    return sharedInstance;
}

- (id)init {
    if ((self = [super init])) {
        self.firstname = @"";
        self.lastname = @"";
        self.username = @"";
        self.hash = @"";
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
        self.loggedIn = NO;
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (oneway void)release {
    
}

- (id)autorelease {
    return self;
}

- (void)createProfile:(NSDictionary *)dictionary {
    self.firstname = [dictionary objectForKey:@"firstname"];
    self.lastname = [dictionary objectForKey:@"lastname"];
    self.username = [dictionary objectForKey:@"username"];
    self.hash = [dictionary objectForKey:@"password"];
    self.section = [dictionary objectForKey:@"section"];
    self.years = [dictionary objectForKey:@"years"];
    self.status = [dictionary objectForKey:@"status"];
    self.sl = [[dictionary objectForKey:@"SL"] boolValue];
    self.instructor = [[dictionary objectForKey:@"instructor"] boolValue];
    self.admin = [[dictionary objectForKey:@"admin"] boolValue];
    self.phonenumber = [dictionary objectForKey:@"phonenumber"];
    self.email = [dictionary objectForKey:@"email"];
    self.birthday = [dictionary objectForKey:@"birthday"];
    self.valid = [[dictionary objectForKey:@"valid"] boolValue];
    self.lastlogin = [dictionary objectForKey:@"lastlogin"];
    self.paid = [[dictionary objectForKey:@"paid"] boolValue];
    self.loggedIn = YES;
}

- (void)destroyProfile {
    self.firstname = @"";
    self.lastname = @"";
    self.username = @"";
    self.hash = @"";
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
    self.loggedIn = NO;
}


@end
