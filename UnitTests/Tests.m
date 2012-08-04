//
//  Tests.m
//  TexasDrums
//
//  Created by Corey Roberts on 2/20/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <GHUnitIOS/GHUNit.h>
#import <SenTestingKit/SenTestingKit.h>
#import "CJSONDeserializer.h"

#import "UserProfile.h"

// Requests
#import "TexasDrumsGetNews.h"
#import "TexasDrumsGetRosters.h"
#import "TexasDrumsGetFAQ.h"
#import "TexasDrumsGetVideos.h"
#import "TexasDrumsGetMemberLogin.h"
#import "TexasDrumsGetMemberLogout.h"
#import "TexasDrumsGetGigs.h"
#import "TexasDrumsGetEditProfile.h"
#import "TexasDrumsGetMusic.h"
#import "TexasDrumsGetAccounts.h"
#import "TexasDrumsGetAbout.h"
#import "TexasDrumsGetStaff.h"
#import "TexasDrumsGetPaymentUpdate.h"

// News
#import "News.h"
#import "NewsViewController.h"

// Roster
#import "Roster.h"
#import "RosterMember.h"
#import "RosterViewController.h"

// Media
#import "Video.h"


@interface NewsTests : GHTestCase { }
@property (retain) News *news;
@end

@implementation NewsTests
@synthesize news;

- (void)setUp {
    self.news = [[[News alloc] init] autorelease];
}

- (void)tearDown {
    self.news = nil;
}

- (void)testNewsInitialization {
    GHAssertNotNil(news, nil);
    GHAssertEqualStrings(news.post, @"", nil);
    GHAssertEqualStrings(news.titleOfPost, @"", nil);
    GHAssertEqualStrings(news.author, @"", nil);
    GHAssertEqualStrings(news.time, @"", nil);
    GHAssertLessThan(news.timestamp, 0, nil);
    GHAssertEqualStrings(news.postDate, @"", nil);
    GHAssertEqualStrings(news.subtitle, @"", nil);
    GHAssertFalse(news.memberPost, nil);
    GHAssertFalse(news.sticky, nil);
}

- (void)testCreateNewsPost1 {
    NSArray *objects = [NSArray arrayWithObjects:@"Content", @"Date", @"FirstName", @"Time", @"Timestamp", @"Title", @"MemberNews", nil];
    NSArray *keys    = [NSArray arrayWithObjects:@"content", @"date", @"firstname", @"time", @"timestamp", @"title", @"membernews", nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    self.news = [News createNewPost:dictionary];
    GHAssertNotNil(news, nil);
}

- (void)testCreateNewsPost2 {
    NSArray *objects = [NSArray arrayWithObjects:@"Content", @"Date", @"FirstName", @"Time", @"Timestamp", @"Title", @"MemberNews", nil];
    NSArray *keys    = [NSArray arrayWithObjects:@"content", @"date", @"firstname", @"time", @"timestamp", @"title", @"membernews", nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    self.news = [News createNewPost:dictionary];
    GHAssertNotNil(news, nil);
    GHAssertNotNil(news.post, nil);
    GHAssertNotNil(news.titleOfPost, nil);
    GHAssertNotNil(news.author, nil);
    GHAssertNotNil(news.postDate, nil);
    GHAssertNotNil(news.subtitle, nil);
}

- (void)testCreateNewsPost3 {
    NSArray *objects = [NSArray arrayWithObjects:@"Content", @"Date", @"FirstName", @"Time", @"Timestamp", @"Title", @"1", @"1", nil];
    NSArray *keys    = [NSArray arrayWithObjects:@"content", @"date", @"firstname", @"time", @"timestamp", @"title", @"membernews", @"sticky", nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    self.news = [News createNewPost:dictionary];
    GHAssertNotNil(news, nil);
    GHAssertNotNil(news.post, nil);
    GHAssertNotNil(news.titleOfPost, nil);
    GHAssertNotNil(news.author, nil);
    GHAssertNotNil(news.postDate, nil);
    GHAssertNotNil(news.subtitle, nil);
    GHAssertTrue(news.memberPost, nil);
    GHAssertTrue(news.sticky, nil);
}

@end

@interface RosterTests : GHTestCase { }
@property (retain) RosterMember *rosterMember;
@end

@implementation RosterTests
@synthesize rosterMember;

- (void)setUp {
    self.rosterMember = [[[RosterMember alloc] init] autorelease];
}

- (void)tearDown {
    self.rosterMember = nil;
}

- (void)testRosterInitialization {
    
    NSString *year = @"2012";
    
    Roster *roster = [[[Roster alloc] initWithYear:year] autorelease];
    
    GHAssertNotNil(roster.snares, nil);
    GHAssertNotNil(roster.tenors, nil);
    GHAssertNotNil(roster.basses, nil);
    GHAssertNotNil(roster.cymbals, nil);
    GHAssertNotNil(roster.instructor, nil);
    GHAssertEquals(roster.the_year, year, nil);
}

- (void)testRosterMemberInitialization {
    GHAssertNotNil(self.rosterMember.firstname, nil);
    GHAssertNotNil(self.rosterMember.nickname, nil);
    GHAssertNotNil(self.rosterMember.lastname, nil);
    GHAssertNotNil(self.rosterMember.fullname, nil);
    GHAssertNotNil(self.rosterMember.instrument, nil);
    GHAssertNotNil(self.rosterMember.classification, nil);
    GHAssertNotNil(self.rosterMember.year, nil);
    GHAssertNotNil(self.rosterMember.amajor, nil);
    GHAssertNotNil(self.rosterMember.hometown, nil);
    GHAssertNotNil(self.rosterMember.quote, nil);
    GHAssertNotNil(self.rosterMember.phone, nil);
    GHAssertNotNil(self.rosterMember.email, nil);
    GHAssertEquals(self.rosterMember.position, -1, nil);
    GHAssertEquals(self.rosterMember.valid, 0, nil);
}

- (void)testCreateRosterMember1 {
    NSArray *objects = [NSArray arrayWithObjects:@"FirstName", @"NickName", @"LastName", @"Instrument", @"Classification", @"Year", @"Major", @"Hometown", @"Quote", @"5", @"Phone", @"Email", @"1", nil];
    NSArray *keys    = [NSArray arrayWithObjects:@"firstname", @"nickname", @"lastname", @"instrument", @"classification", @"year", @"major", @"hometown", @"quote", @"position", @"phone", @"email", @"valid", nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    self.rosterMember = [RosterMember createNewRosterMember:dictionary];
    
    GHAssertNotNil(self.rosterMember.nickname, nil);
    GHAssertNotNil(self.rosterMember.lastname, nil);
    GHAssertNotNil(self.rosterMember.fullname, nil);
    GHAssertNotNil(self.rosterMember.instrument, nil);
    GHAssertNotNil(self.rosterMember.classification, nil);
    GHAssertNotNil(self.rosterMember.year, nil);
    GHAssertNotNil(self.rosterMember.amajor, nil);
    GHAssertNotNil(self.rosterMember.hometown, nil);
    GHAssertNotNil(self.rosterMember.quote, nil);
    GHAssertNotNil(self.rosterMember.phone, nil);
    GHAssertNotNil(self.rosterMember.email, nil);
    GHAssertEquals(self.rosterMember.position, 5, nil);
    GHAssertEquals(self.rosterMember.valid, 1, nil);
}

- (void)testCreateRosterMember2 {
    NSArray *objects = [NSArray arrayWithObjects:@"FirstName", @"NickName", @"LastName", @"Snare", @"Classification", @"Year", @"Major", @"Hometown", @"Quote", @"5", @"Phone", @"Email", @"1", nil];
    NSArray *keys    = [NSArray arrayWithObjects:@"firstname", @"nickname", @"lastname", @"instrument", @"classification", @"year", @"major", @"hometown", @"quote", @"position", @"phone", @"email", @"valid", nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    self.rosterMember = [RosterMember createNewRosterMember:dictionary];
    

    GHAssertEqualStrings(self.rosterMember.firstname, @"FirstName", nil);
    GHAssertEqualStrings(self.rosterMember.lastname, @"LastName", nil);
    GHAssertEqualStrings(self.rosterMember.nickname, @"NickName", nil);
    GHAssertEqualStrings(self.rosterMember.fullname, @"FirstName LastName", nil);
    GHAssertEqualStrings(self.rosterMember.instrument, @"Snare", nil);
    GHAssertEqualStrings(self.rosterMember.classification, @"Classification", nil);
    GHAssertEqualStrings(self.rosterMember.year, @"Year", nil);
    GHAssertEqualStrings(self.rosterMember.amajor, @"Major", nil);
    GHAssertEqualStrings(self.rosterMember.hometown, @"Hometown", nil);
    GHAssertEqualStrings(self.rosterMember.quote, @"Quote", nil);
    GHAssertEqualStrings(self.rosterMember.phone, @"n/a", nil);
    GHAssertEqualStrings(self.rosterMember.email, @"Email", nil);
    GHAssertEquals(self.rosterMember.position, 5, nil);
    GHAssertEquals(self.rosterMember.valid, 1, nil);
}

- (void)testAddMember1 {
    NSString *year = @"2012";
    Roster *roster = [[[Roster alloc] initWithYear:year] autorelease];
    
    NSArray *objects = [NSArray arrayWithObjects:@"FirstName", @"NickName", @"LastName", @"Snare", @"Classification", @"Year", @"Major", @"Hometown", @"Quote", @"5", @"Phone", @"Email", @"1", nil];
    NSArray *keys    = [NSArray arrayWithObjects:@"firstname", @"nickname", @"lastname", @"instrument", @"classification", @"year", @"major", @"hometown", @"quote", @"position", @"phone", @"email", @"valid", nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    RosterMember *member = [RosterMember createNewRosterMember:dictionary];
    [roster addMember:member];
    
    GHAssertTrue(roster.snares.count == 1, nil);
    
    
    objects = [NSArray arrayWithObjects:@"FirstName", @"NickName", @"LastName", @"Tenors", @"Classification", @"Year", @"Major", @"Hometown", @"Quote", @"5", @"Phone", @"Email", @"1", nil];
    dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    member = [RosterMember createNewRosterMember:dictionary];
    [roster addMember:member];
    
    GHAssertTrue(roster.tenors.count == 1, nil);
    
    objects = [NSArray arrayWithObjects:@"FirstName", @"NickName", @"LastName", @"Bass", @"Classification", @"Year", @"Major", @"Hometown", @"Quote", @"5", @"Phone", @"Email", @"1", nil];
    dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    member = [RosterMember createNewRosterMember:dictionary];
    [roster addMember:member];
    
    GHAssertTrue(roster.basses.count == 1, nil);
    
    objects = [NSArray arrayWithObjects:@"FirstName", @"NickName", @"LastName", @"Cymbals", @"Classification", @"Year", @"Major", @"Hometown", @"Quote", @"5", @"Phone", @"Email", @"1", nil];
    dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    member = [RosterMember createNewRosterMember:dictionary];
    [roster addMember:member];
    
    GHAssertTrue(roster.cymbals.count == 1, nil);
}

- (void)testSortSections1 {
    NSString *year = @"2012";
    Roster *roster = [[[Roster alloc] initWithYear:year] autorelease];
    
    NSArray *objects;
    NSArray *keys = [NSArray arrayWithObjects:@"firstname", @"nickname", @"lastname", @"instrument", @"classification", @"year", @"major", @"hometown", @"quote", @"position", @"phone", @"email", @"valid", nil];
    NSDictionary *dictionary;
    RosterMember *member;
    
    
    // Create snares.
    for(int i = 1; i <= 10; i++) {
        NSString *position = [NSString stringWithFormat:@"%d", i];
        objects = [NSArray arrayWithObjects:@"FirstName", @"NickName", @"LastName", @"Snare", @"Classification", @"Year", @"Major", @"Hometown", @"Quote", position , @"Phone", @"Email", @"1", nil];
        dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        member = [RosterMember createNewRosterMember:dictionary];
        [roster addMember:member];
    }
    
    GHAssertTrue(roster.snares.count == 10, nil);
    [roster sortSections];
    
    // Snares are sorted in an opposite manner.
    for(int i = 0; i < 10; i++) {
        RosterMember *member = [roster.snares objectAtIndex:i];
        GHAssertTrue(10-i == member.position, nil);
    }
    
    // Create tenors.
    for(int i = 1; i <= 10; i++) {
        NSString *position = [NSString stringWithFormat:@"%d", i];
        objects = [NSArray arrayWithObjects:@"FirstName", @"NickName", @"LastName", @"Tenors", @"Classification", @"Year", @"Major", @"Hometown", @"Quote", position , @"Phone", @"Email", @"1", nil];
        dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        member = [RosterMember createNewRosterMember:dictionary];
        [roster addMember:member];
    }
    
    GHAssertTrue(roster.tenors.count == 10, nil);
    [roster sortSections];
    
    // Snares are sorted in an opposite manner.
    // Tenors are not.
    for(int i = 0; i < 10; i++) {
        RosterMember *member = [roster.snares objectAtIndex:i];
        GHAssertTrue(10-i == member.position, nil);
        
        member = [roster.tenors objectAtIndex:i];
        GHAssertTrue(i+1 == member.position, nil);
    }

}

- (void)testSortSections2 {
    NSString *year = @"2012";
    Roster *roster = [[[Roster alloc] initWithYear:year] autorelease];
    
    NSArray *objects;
    NSArray *keys = [NSArray arrayWithObjects:@"firstname", @"nickname", @"lastname", @"instrument", @"classification", @"year", @"major", @"hometown", @"quote", @"position", @"phone", @"email", @"valid", nil];
    NSDictionary *dictionary;
    RosterMember *member;
    
    
    // Create snares.
    for(int i = 1; i <= 10; i=i+2) {
        NSString *position = [NSString stringWithFormat:@"%d", i];
        objects = [NSArray arrayWithObjects:@"FirstName", @"NickName", @"LastName", @"Snare", @"Classification", @"Year", @"Major", @"Hometown", @"Quote", position , @"Phone", @"Email", @"1", nil];
        dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        member = [RosterMember createNewRosterMember:dictionary];
        [roster addMember:member];
    }
    
    for(int i = 0; i <= 10; i=i+2) {
        NSString *position = [NSString stringWithFormat:@"%d", i];
        objects = [NSArray arrayWithObjects:@"FirstName", @"NickName", @"LastName", @"Snare", @"Classification", @"Year", @"Major", @"Hometown", @"Quote", position , @"Phone", @"Email", @"1", nil];
        dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        member = [RosterMember createNewRosterMember:dictionary];
        [roster addMember:member];
    }
    
    GHAssertTrue(roster.snares.count == 11, nil);
    [roster sortSections];
    
    // Snares are sorted in an opposite manner.
    for(int i = 0; i < 11; i++) {
        RosterMember *member = [roster.snares objectAtIndex:i];
        GHAssertTrue(10-i == member.position, nil);
    }
    
    // Create tenors.
    for(int i = 1; i <= 10; i++) {
        NSString *position = [NSString stringWithFormat:@"%d", i];
        objects = [NSArray arrayWithObjects:@"FirstName", @"NickName", @"LastName", @"Tenors", @"Classification", @"Year", @"Major", @"Hometown", @"Quote", position , @"Phone", @"Email", @"1", nil];
        dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        member = [RosterMember createNewRosterMember:dictionary];
        [roster addMember:member];
    }
    
    GHAssertTrue(roster.tenors.count == 10, nil);
    [roster sortSections];
    
    // Snares are sorted in an opposite manner.
    // Tenors are not.
    for(int i = 0; i < 10; i++) {
        RosterMember *member = [roster.snares objectAtIndex:i];
        GHAssertTrue(10-i == member.position, nil);
        
        member = [roster.tenors objectAtIndex:i];
        GHAssertTrue(i+1 == member.position, nil);
    }
    
}

- (void)testCreateRoster1 {
    
    NSString *year = @"2012";
    
    NSArray *objects = [NSArray arrayWithObjects:@"FirstName", @"NickName", @"LastName", @"Snare", @"Classification", @"Year", @"Major", @"Hometown", @"Quote", @"5", @"Phone", @"Email", @"1", nil];
    NSArray *keys    = [NSArray arrayWithObjects:@"firstname", @"nickname", @"lastname", @"instrument", @"classification", @"year", @"major", @"hometown", @"quote", @"position", @"phone", @"email", @"valid", nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    RosterMember *rosterMemberSnare = [RosterMember createNewRosterMember:dictionary];

    objects = [NSArray arrayWithObjects:@"FirstName", @"NickName", @"LastName", @"Tenors", @"Classification", @"Year", @"Major", @"Hometown", @"Quote", @"5", @"Phone", @"Email", @"1", nil];
    keys    = [NSArray arrayWithObjects:@"firstname", @"nickname", @"lastname", @"instrument", @"classification", @"year", @"major", @"hometown", @"quote", @"position", @"phone", @"email", @"valid", nil];
    dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    RosterMember *rosterMemberTenors = [RosterMember createNewRosterMember:dictionary];
    
    objects = [NSArray arrayWithObjects:@"FirstName", @"NickName", @"LastName", @"Bass", @"Classification", @"Year", @"Major", @"Hometown", @"Quote", @"5", @"Phone", @"Email", @"1", nil];
    keys    = [NSArray arrayWithObjects:@"firstname", @"nickname", @"lastname", @"instrument", @"classification", @"year", @"major", @"hometown", @"quote", @"position", @"phone", @"email", @"valid", nil];
    dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    RosterMember *rosterMemberBass = [RosterMember createNewRosterMember:dictionary];
    
    objects = [NSArray arrayWithObjects:@"FirstName", @"NickName", @"LastName", @"Cymbals", @"Classification", @"Year", @"Major", @"Hometown", @"Quote", @"5", @"Phone", @"Email", @"1", nil];
    keys    = [NSArray arrayWithObjects:@"firstname", @"nickname", @"lastname", @"instrument", @"classification", @"year", @"major", @"hometown", @"quote", @"position", @"phone", @"email", @"valid", nil];
    dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    RosterMember *rosterMemberCymbals = [RosterMember createNewRosterMember:dictionary];
    
    objects = [NSArray arrayWithObjects:@"FirstName", @"NickName", @"LastName", @"Instructor", @"Classification", @"Year", @"Major", @"Hometown", @"Quote", @"5", @"Phone", @"Email", @"1", nil];
    keys    = [NSArray arrayWithObjects:@"firstname", @"nickname", @"lastname", @"instrument", @"classification", @"year", @"major", @"hometown", @"quote", @"position", @"phone", @"email", @"valid", nil];
    dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    RosterMember *rosterMemberInstructor = [RosterMember createNewRosterMember:dictionary];
    
    Roster *roster = [[[Roster alloc] initWithYear:year] autorelease];
    
    [roster addMember:rosterMemberSnare];
    GHAssertTrue(roster.snares.count == 1, nil);
    GHAssertTrue(roster.tenors.count == 0, nil);
    GHAssertTrue(roster.basses.count == 0, nil);
    GHAssertTrue(roster.cymbals.count == 0, nil);
    GHAssertTrue(roster.instructor.count == 0, nil);
    
    [roster addMember:rosterMemberTenors];
    GHAssertTrue(roster.snares.count == 1, nil);
    GHAssertTrue(roster.tenors.count == 1, nil);
    GHAssertTrue(roster.basses.count == 0, nil);
    GHAssertTrue(roster.cymbals.count == 0, nil);
    GHAssertTrue(roster.instructor.count == 0, nil);
    
    [roster addMember:rosterMemberBass];
    GHAssertTrue(roster.snares.count == 1, nil);
    GHAssertTrue(roster.tenors.count == 1, nil);
    GHAssertTrue(roster.basses.count == 1, nil);
    GHAssertTrue(roster.cymbals.count == 0, nil);
    GHAssertTrue(roster.instructor.count == 0, nil);
    
    [roster addMember:rosterMemberCymbals];
    GHAssertTrue(roster.snares.count == 1, nil);
    GHAssertTrue(roster.tenors.count == 1, nil);
    GHAssertTrue(roster.basses.count == 1, nil);
    GHAssertTrue(roster.cymbals.count == 1, nil);
    GHAssertTrue(roster.instructor.count == 0, nil);
    
    [roster addMember:rosterMemberInstructor];
    GHAssertTrue(roster.snares.count == 1, nil);
    GHAssertTrue(roster.tenors.count == 1, nil);
    GHAssertTrue(roster.basses.count == 1, nil);
    GHAssertTrue(roster.cymbals.count == 1, nil);
    GHAssertTrue(roster.instructor.count == 1, nil);
    
    for(int i = 0; i < 9; i++) {
        [roster addMember:rosterMemberSnare];
        [roster addMember:rosterMemberBass];
        [roster addMember:rosterMemberTenors];
        [roster addMember:rosterMemberCymbals];
    }
    
    GHAssertTrue(roster.snares.count == 10, nil);
    GHAssertTrue(roster.tenors.count == 10, nil);
    GHAssertTrue(roster.basses.count == 10, nil);
    GHAssertTrue(roster.cymbals.count == 10, nil);
    GHAssertTrue(roster.instructor.count == 1, nil);
}

@end

@interface VideoTests : GHTestCase { }
/*
- (void)setUp { }

- (void)tearDown { }

- (void)testVideoInitialization { }
 */

@end

@implementation VideoTests

@end

/****************************************************************************************************
 * API INTEGRATION TESTS                                                                            *
 * ------------------------------------------------------------------------------------------------ *
 * These tests take an API call, make a request to the server, and wait for a response.             *
 * The max timeout for each request is 5 seconds, and expects some of the following responses:      *
 * "200 OK"             -> Responses that are commands and modify the database.                     *
 * "404 UNAUTHORIZED"   -> Responses that are unauthorized for users without permission.            *
 * "403 UNKNOWN ERROR"  -> Responses that react to invalid queries.                                 *
 * { JSON }             -> Responses that return an acceptable and parseable JSON string.           *
 ****************************************************************************************************/

@interface APITests : GHAsyncTestCase { }
@property (nonatomic, copy) NSString *selectorName;
@property (nonatomic, copy) NSString *badUsername;
@property (nonatomic, copy) NSString *badPassword;
@end

@implementation APITests
@synthesize selectorName, badUsername, badPassword;

- (void)setUp {
    [UserProfile sharedInstance].username = @"iostester";
    [UserProfile sharedInstance].hash = @"!amacak3";
    self.badUsername = @"badusername";
    self.badPassword = @"badpassword";
}

- (void)tearDown {
    self.selectorName = nil;
    [UserProfile sharedInstance].username = nil;
    [UserProfile sharedInstance].hash = nil;
}

/****************************************************************************************************
 * NEWS API TESTS                                                                                   *
 ****************************************************************************************************/

- (void)testGetNewsRequest {
    self.selectorName = @"testGetNewsRequest";
    
    // Prepare for asynchronous call
    [self prepare];
    
    // Do asynchronous task here
    TexasDrumsGetNews *get = [[TexasDrumsGetNews alloc] initWithTimestamp:0];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetNewsRequestMaxTimestamp {
    self.selectorName = @"testGetNewsRequestMaxTimestamp";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetNews *get = [[TexasDrumsGetNews alloc] initWithTimestamp:NSIntegerMax];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

/****************************************************************************************************
 * ROSTER API TESTS                                                                                 *
 ****************************************************************************************************/

- (void)testGetRostersRequest {
    self.selectorName = @"testGetRostersRequest";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetRosters *get = [[TexasDrumsGetRosters alloc] init];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

/****************************************************************************************************
 * FAQ API TESTS                                                                                    *
 ****************************************************************************************************/

- (void)testGetFAQRequest {
    self.selectorName = @"testGetFAQRequest";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetFAQ *get = [[TexasDrumsGetFAQ alloc] init];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

/****************************************************************************************************
 * VIDEO API TESTS                                                                                  *
 ****************************************************************************************************/

- (void)testGetVideosRequest {
    self.selectorName = @"testGetVideosRequest";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetVideos *get = [[TexasDrumsGetVideos alloc] init];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

/****************************************************************************************************
 * MEMBER LOGIN API TESTS                                                                           *
 ****************************************************************************************************/

- (void)testGetMemberLoginRequest {
    self.selectorName = @"testGetMemberLoginRequest";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetMemberLogin *get = [[TexasDrumsGetMemberLogin alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                           andPassword:[UserProfile sharedInstance].hash];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetMemberLoginRequestInvalidCredentials {
    self.selectorName = @"testGetMemberLoginRequestInvalidCredentials";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetMemberLogin *get = [[TexasDrumsGetMemberLogin alloc] initWithUsername:self.badUsername
                                                                           andPassword:self.badPassword];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:5.0];
}

/****************************************************************************************************
 * MEMBER LOGOUT API TESTS                                                                          *
 ****************************************************************************************************/

- (void)testGetMemberLogoutRequest {
    self.selectorName = @"testGetMemberLogoutRequest";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetMemberLogout *get = [[TexasDrumsGetMemberLogout alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                             andPassword:[UserProfile sharedInstance].hash];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetMemberLogoutRequestInvalidCredentials {
    self.selectorName = @"testGetMemberLogoutRequestInvalidCredentials";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetMemberLogout *get = [[TexasDrumsGetMemberLogout alloc] initWithUsername:self.badUsername
                                                                             andPassword:self.badPassword];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:5.0];
}

/****************************************************************************************************
 * GIGS API TESTS                                                                                   *
 ****************************************************************************************************/

- (void)testGetGigsRequest {
    self.selectorName = @"testGetGigsRequest";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetGigs *get = [[TexasDrumsGetGigs alloc] initWithUsername:[UserProfile sharedInstance].username
                                                             andPassword:[UserProfile sharedInstance].hash];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetGigsRequestInvalidCredentials {
    self.selectorName = @"testGetGigsRequestInvalidCredentials";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetGigs *get = [[TexasDrumsGetGigs alloc] initWithUsername:self.badUsername
                                                             andPassword:self.badPassword];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:5.0];
}

/****************************************************************************************************
 * EDIT PROFILE API TESTS                                                                           *
 ****************************************************************************************************/

- (void)testGetEditProfileEditFirstNameShouldFail {
    self.selectorName = @"testGetEditProfileEditFirstNameShouldFail";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetEditProfile *get = [[TexasDrumsGetEditProfile alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                           andPassword:[UserProfile sharedInstance].hash
                                                                         withFirstName:@"Hello"
                                                                           andLastName:nil
                                                                    andUpdatedPassword:nil
                                                                              andPhone:nil
                                                                           andBirthday:nil
                                                                              andEmail:nil];
    
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:5.0];
}

- (void)testGetEditProfileEditLastNameShouldFail {
    self.selectorName = @"testGetEditProfileEditLastNameShouldFail";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetEditProfile *get = [[TexasDrumsGetEditProfile alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                           andPassword:[UserProfile sharedInstance].hash
                                                                         withFirstName:nil
                                                                           andLastName:@"World"
                                                                    andUpdatedPassword:nil
                                                                              andPhone:nil
                                                                           andBirthday:nil
                                                                              andEmail:nil];
    
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:5.0];
}

- (void)testGetEditProfileEditFullName {
    self.selectorName = @"testGetEditProfileEditFullName";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetEditProfile *get = [[TexasDrumsGetEditProfile alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                           andPassword:[UserProfile sharedInstance].hash
                                                                         withFirstName:@"Hello"
                                                                           andLastName:@"World"
                                                                    andUpdatedPassword:nil
                                                                              andPhone:nil
                                                                           andBirthday:nil
                                                                              andEmail:nil];
    
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetEditProfileEditPassword {
    self.selectorName = @"testGetEditProfileEditPassword";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetEditProfile *get = [[TexasDrumsGetEditProfile alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                           andPassword:[UserProfile sharedInstance].hash
                                                                         withFirstName:nil
                                                                           andLastName:nil
                                                                    andUpdatedPassword:@"!amacak3"
                                                                              andPhone:nil
                                                                           andBirthday:nil
                                                                              andEmail:nil];
    
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetEditProfileEditPhone {
    self.selectorName = @"testGetEditProfileEditPhone";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetEditProfile *get = [[TexasDrumsGetEditProfile alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                           andPassword:[UserProfile sharedInstance].hash
                                                                         withFirstName:nil
                                                                           andLastName:nil
                                                                    andUpdatedPassword:nil
                                                                              andPhone:@"1234567890"
                                                                           andBirthday:nil
                                                                              andEmail:nil];
    
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetEditProfileEditBirthday {
    self.selectorName = @"testGetEditProfileEditBirthday";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetEditProfile *get = [[TexasDrumsGetEditProfile alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                           andPassword:[UserProfile sharedInstance].hash
                                                                         withFirstName:nil
                                                                           andLastName:nil
                                                                    andUpdatedPassword:nil
                                                                              andPhone:nil
                                                                           andBirthday:@"12345678"
                                                                              andEmail:nil];
    
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetEditProfileEditEmail {
    self.selectorName = @"testGetEditProfileEditEmail";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetEditProfile *get = [[TexasDrumsGetEditProfile alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                           andPassword:[UserProfile sharedInstance].hash
                                                                         withFirstName:nil
                                                                           andLastName:nil
                                                                    andUpdatedPassword:nil
                                                                              andPhone:nil
                                                                           andBirthday:nil
                                                                              andEmail:@"hack@me.com"];
    
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetEditProfileEditMultiple1 {
    self.selectorName = @"testGetEditProfileEditMultiple1";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetEditProfile *get = [[TexasDrumsGetEditProfile alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                           andPassword:[UserProfile sharedInstance].hash
                                                                         withFirstName:@"Hello"
                                                                           andLastName:@"World"
                                                                    andUpdatedPassword:nil
                                                                              andPhone:nil
                                                                           andBirthday:@"12345678"
                                                                              andEmail:@"hack@me.com"];
    
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetEditProfileEditMultiple2 {
    self.selectorName = @"testGetEditProfileEditMultiple2";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetEditProfile *get = [[TexasDrumsGetEditProfile alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                           andPassword:[UserProfile sharedInstance].hash
                                                                         withFirstName:@"Hello"
                                                                           andLastName:@"World"
                                                                    andUpdatedPassword:@"!amacak3"
                                                                              andPhone:@"1234567890"
                                                                           andBirthday:nil
                                                                              andEmail:nil];
    
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetEditProfileEditAll {
    self.selectorName = @"testGetEditProfileEditAll";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetEditProfile *get = [[TexasDrumsGetEditProfile alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                           andPassword:[UserProfile sharedInstance].hash
                                                                         withFirstName:@"Hello"
                                                                           andLastName:@"World"
                                                                    andUpdatedPassword:@"!amacak3"
                                                                              andPhone:@"1234567890"
                                                                           andBirthday:@"12345678"
                                                                              andEmail:@"hack@me.com"];
    
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetEditProfileEditNoneShouldFail {
    self.selectorName = @"testGetEditProfileEditNoneShouldFail";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetEditProfile *get = [[TexasDrumsGetEditProfile alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                           andPassword:[UserProfile sharedInstance].hash
                                                                         withFirstName:nil
                                                                           andLastName:nil
                                                                    andUpdatedPassword:nil
                                                                              andPhone:nil
                                                                           andBirthday:nil
                                                                              andEmail:nil];
    
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:5.0];
}

/****************************************************************************************************
 * MUSIC API TESTS                                                                                  *
 ****************************************************************************************************/

- (void)testGetMusicRequest {
    self.selectorName = @"testGetMusicRequest";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetMusic *get = [[TexasDrumsGetMusic alloc] initWithUsername:[UserProfile sharedInstance].username
                                                             andPassword:[UserProfile sharedInstance].hash];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetMusicRequestInvalidCredentials {
    self.selectorName = @"testGetMusicRequestInvalidCredentials";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetMusic *get = [[TexasDrumsGetMusic alloc] initWithUsername:self.badUsername
                                                               andPassword:self.badPassword];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:5.0];
}

/****************************************************************************************************
 * ACCOUNTS API TESTS                                                                               *
 ****************************************************************************************************/

- (void)testGetAccountsRequest {
    self.selectorName = @"testGetAccountsRequest";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetAccounts *get = [[TexasDrumsGetAccounts alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                     andPassword:[UserProfile sharedInstance].hash];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetAccountsRequestInvalidCredentials {
    self.selectorName = @"testGetAccountsRequestInvalidCredentials";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetAccounts *get = [[TexasDrumsGetAccounts alloc] initWithUsername:self.badUsername
                                                                     andPassword:self.badPassword];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:5.0];
}

/****************************************************************************************************
 * ABOUT API TESTS                                                                                  *
 ****************************************************************************************************/

- (void)testGetAboutRequest {
    self.selectorName = @"testGetAboutRequest";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetAbout *get = [[TexasDrumsGetAbout alloc] init];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

/****************************************************************************************************
 * STAFF API TESTS                                                                                  *
 ****************************************************************************************************/

- (void)testGetStaffRequest {
    self.selectorName = @"testGetStaffRequest";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetStaff *get = [[TexasDrumsGetStaff alloc] init];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

/****************************************************************************************************
 * UPDATE PAYMENT API TESTS                                                                         *
 ****************************************************************************************************/

- (void)testGetPaymentRequestPaid {
    self.selectorName = @"testGetPaymentRequestPaid";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetPaymentUpdate *get = [[TexasDrumsGetPaymentUpdate alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                               andPassword:[UserProfile sharedInstance].hash
                                                                                   andUser:[UserProfile sharedInstance].username
                                                                                   andPaid:[NSNumber numberWithInt:1]];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetPaymentRequestNotPaid {
    self.selectorName = @"testGetPaymentRequestNotPaid";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetPaymentUpdate *get = [[TexasDrumsGetPaymentUpdate alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                               andPassword:[UserProfile sharedInstance].hash
                                                                                   andUser:[UserProfile sharedInstance].username
                                                                                   andPaid:[NSNumber numberWithInt:0]];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetPaymentRequestInvalidCredentials {
    self.selectorName = @"testGetPaymentRequestInvalidCredentials";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetPaymentUpdate *get = [[TexasDrumsGetPaymentUpdate alloc] initWithUsername:self.badUsername
                                                                               andPassword:self.badPassword
                                                                                   andUser:[UserProfile sharedInstance].username
                                                                                   andPaid:[NSNumber numberWithInt:1]];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:5.0];
}

- (void)testGetPaymentRequestInvalidUser {
    self.selectorName = @"testGetPaymentRequestInvalidUser";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetPaymentUpdate *get = [[TexasDrumsGetPaymentUpdate alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                               andPassword:[UserProfile sharedInstance].hash
                                                                                   andUser:self.badUsername
                                                                                   andPaid:[NSNumber numberWithInt:1]];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:5.0];
}

/****************************************************************************************************
 * API RESPONDERS                                                                                   *
 ****************************************************************************************************/

#pragma mark - TexasDrumsRequest Delegate Methods

- (void)request:(TexasDrumsRequest *)request receivedData:(id)data {
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:data error:&error];
    
    if([results count] > 0){
        // Special cases to consider if request returns a status response.
        if([results respondsToSelector:@selector(objectForKey:)] ){
            NSString *status = [results objectForKey:@"status"];
            
            if([request isMemberOfClass:[TexasDrumsGetNews class]]) {
                if([status isEqualToString:_NEWS_API_NO_NEW_ARTICLES]) {
                    [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(selectorName)];
                }
                else {
                    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(selectorName)];
                }
            }
            
            if([request isMemberOfClass:[TexasDrumsGetMemberLogin class]]) {
                if([status isEqualToString:_404_UNAUTHORIZED]) {
                    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(selectorName)];
                }
                else {
                    [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(selectorName)];
                }
            }
            
            if([request isMemberOfClass:[TexasDrumsGetMemberLogout class]]) {
                if([status isEqualToString:_200_OK]) {
                    [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(selectorName)];
                }
                else {
                    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(selectorName)];
                }
            }
            
            if([request isMemberOfClass:[TexasDrumsGetGigs class]]) {
                if([status isEqualToString:_404_UNAUTHORIZED]) {
                    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(selectorName)];
                }
            }
            
            if([request isMemberOfClass:[TexasDrumsGetEditProfile class]]) {
                if([status isEqualToString:_200_OK]) {
                    [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(selectorName)];
                }
                else {
                    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(selectorName)];
                }
            }
            
            if([request isMemberOfClass:[TexasDrumsGetMusic class]]) {
                if([status isEqualToString:_404_UNAUTHORIZED]) {
                    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(selectorName)];
                }
            }
            
            if([request isMemberOfClass:[TexasDrumsGetAccounts class]]) {
                if([status isEqualToString:_404_UNAUTHORIZED]) {
                    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(selectorName)];
                }
            }
            
            if([request isMemberOfClass:[TexasDrumsGetPaymentUpdate class]]) {
                if([status isEqualToString:_200_OK]) {
                    [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(selectorName)];
                }
                else {
                    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(selectorName)];
                }
            }
            
        }
        else {
            if(error == nil) {
                // If we made it here, we got an acceptable JSON response that was successfully parsed.
                [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(selectorName)];
            }
        }
    }
    else {
        [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(selectorName)];
    }
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testGetNewsRequest)];
}
 
@end