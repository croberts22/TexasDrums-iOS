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


// API Tests
@interface APITests : GHAsyncTestCase { }
@property (nonatomic, retain) NSString *selectorName;
@end

@implementation APITests
@synthesize selectorName;

// News API Tests
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

// Roster API Tests
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

// FAQ API Tests
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

// Video API Tests
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

// Member Login API Tests
- (void)testGetMemberLoginRequest {
    self.selectorName = @"testGetMemberLoginRequest";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetMemberLogin *get = [[TexasDrumsGetMemberLogin alloc] initWithUsername:@"tboyd" andPassword:@"tboyd"];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetMemberLoginRequestInvalidCredentials {
    self.selectorName = @"testGetMemberLoginRequestInvalidCredentials";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetMemberLogin *get = [[TexasDrumsGetMemberLogin alloc] initWithUsername:@"herpderp" andPassword:@"!"];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:5.0];
}

// Member Logout API Tests
- (void)testGetMemberLogoutRequest {
    self.selectorName = @"testGetMemberLogoutRequest";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetMemberLogout *get = [[TexasDrumsGetMemberLogout alloc] initWithUsername:@"tboyd" andPassword:@"tboyd"];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetMemberLogoutRequestInvalidCredentials {
    self.selectorName = @"testGetMemberLogoutRequestInvalidCredentials";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetMemberLogout *get = [[TexasDrumsGetMemberLogout alloc] initWithUsername:@"herp" andPassword:@"derp"];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:5.0];
}

// Gigs API Tests
- (void)testGetGigsRequest {
    self.selectorName = @"testGetGigsRequest";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetGigs *get = [[TexasDrumsGetGigs alloc] initWithUsername:@"tboyd" andPassword:@"tboyd"];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5.0];
}

- (void)testGetGigsRequestInvalidCredentials {
    self.selectorName = @"testGetGigsRequestInvalidCredentials";
    
    // Prepare for asynchronous call
    [self prepare];
    
    TexasDrumsGetGigs *get = [[TexasDrumsGetGigs alloc] initWithUsername:@"herp" andPassword:@"derp"];
    get.delegate = self;
    [get startRequest];
    
    // Wait for notify
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:5.0];
}

// Edit Profile API Tests

// Music API Tests

// Accounts API Tests

// About API Tests

// Staff API Tests

// Update Payment API Tests


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