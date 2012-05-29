//
//  Tests.m
//  TexasDrums
//
//  Created by Corey Roberts on 2/20/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <GHUnitIOS/GHUNit.h>
#import "News.h"
#import "NewsViewController.h"

@interface Tests : GHTestCase { }
@property (retain) NewsViewController *NVC;
@property (retain) News *news;
@end

@implementation Tests
@synthesize NVC, news;

- (void)setUp {
    self.NVC = [[[NewsViewController alloc] init] autorelease];
    self.news = [[[News alloc] init] autorelease];
}

- (void)tearDown {
    self.NVC = nil;
    self.news = nil;
}

/* tests don't work due to regexkit_lite not behaving properly with this...hmm 
- (void)testCreateNewsPost {
    NSArray *objects = [NSArray arrayWithObjects:@"Content", @"Date", @"FirstName", @"Time", @"Timestamp", @"Title", @"MemberNews", nil];
    NSArray *keys    = [NSArray arrayWithObjects:@"content", @"date", @"firstName", @"time", @"timestamp", @"title", @"membernews", nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    self.news = [self.NVC createNewPost:dictionary];
    GHAssertNotNil(news, nil);
}

- (void)testExtractHTMLFromPostDefaultHTML {
    NSString *string = @"<html><a href='blahblah'>hello</a></html>";
    NSString *expected_result = @"hello"; 
    NSString *result = [self.NVC extractHTMLFromPost:string];
    
    GHAssertTrue([result isEqualToString:expected_result], @"testExtractHTMLFromPostDefaultHTML failed");
}
*/




@end
