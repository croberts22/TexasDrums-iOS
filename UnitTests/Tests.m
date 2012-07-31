//
//  Tests.m
//  TexasDrums
//
//  Created by Corey Roberts on 2/20/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <GHUnitIOS/GHUNit.h>

// Requests
#import "TexasDrumsGetNews.h"
#import "TexasDrumsGetRosters.h"

// News
#import "News.h"
#import "NewsViewController.h"

// Roster
#import "Roster.h"
#import "RosterMember.h"
#import "RosterViewController.h"

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

// Begin Tests
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
}

@end

@interface APITests : GHTestCase { }
@end

@implementation APITests

@end
