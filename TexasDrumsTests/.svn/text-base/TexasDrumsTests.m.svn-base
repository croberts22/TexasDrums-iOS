//
//  TexasDrumsTests.m
//  TexasDrumsTests
//
//  Created by Corey Roberts on 2/2/12.
//  Copyright 2011 University of Texas at Austin. All rights reserved.
//

#import "TexasDrumsTests.h"

#import "Common.h"
#import "CJSONDeserializer.h"

//News Files
#import "News.h"
#import "NewsViewController.h"


@implementation TexasDrumsTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


/***************************************************************************
 News Tests
 ***************************************************************************/

- (void)testNewsClassImplementation
{
    News *news = [[News alloc] init];
    NSString *_title = @"Title";
    NSString *_post = @"Post";
    NSString *_subtitle = @"Subtitle";
    NSString *_author = @"Author";
    NSString *_date = @"Date";
    NSString *_time = @"Time";
    BOOL _memberPost = TRUE;
    int _timestamp = 0;
    
    news.titleOfPost = [NSString stringWithString:_title];
    news.post = [NSString stringWithString:_post];
    news.subtitle = [NSString stringWithString:_subtitle];
    news.author = [NSString stringWithString:_author];
    news.date = [NSString stringWithString:_date];
    news.time = [NSString stringWithString:_time];
    news.memberPost = _memberPost;
    news.timestamp = _timestamp;
    
    STAssertTrue([news titleOfPost] == _title, @"news.titleOfPost failed: news.titleOfPost returned %@, expected %@", [news titleOfPost], _title);
    STAssertTrue([news post] == _post, @"news.post failed: news.post returned %@, expected %@", [news post], _post);    
    STAssertTrue([news subtitle] == _subtitle, @"news.subtitle failed: news.subtitle returned %@, expected %@", [news subtitle], _subtitle);    
    STAssertTrue([news author] == _author, @"news.author failed: news.author returned %@, expected %@", [news author], _author);    
    STAssertTrue([news date] == _date, @"news.date failed: news.date returned %@, expected %@", [news date], _date);    
    STAssertTrue([news time] == _time, @"news.time failed: news.time returned %@, expected %@", [news time], _time);
    STAssertTrue([news memberPost] == _memberPost, @"news.memberPost failed: news.memberPost returned %@, expected %@", [news memberPost], _memberPost);
    STAssertTrue([news timestamp] == _timestamp, @"news.timestamp failed: news.timestamp returned %@, expected %@", [news timestamp], _timestamp);
    
}

- (void)testNewsClassImplementationEmptyStrings
{
    News *news = [[News alloc] init];
    NSString *_title = @"";
    NSString *_post = @"";
    NSString *_subtitle = @"";
    NSString *_author = @"";
    NSString *_date = @"";
    NSString *_time = @"";
    BOOL _memberPost = TRUE;
    int _timestamp = 0;
    
    news.titleOfPost = [NSString stringWithString:_title];
    news.post = [NSString stringWithString:_post];
    news.subtitle = [NSString stringWithString:_subtitle];
    news.author = [NSString stringWithString:_author];
    news.date = [NSString stringWithString:_date];
    news.time = [NSString stringWithString:_time];
    news.memberPost = _memberPost;
    news.timestamp = _timestamp;
    
    STAssertTrue([news titleOfPost] == _title, @"news.titleOfPost failed: news.titleOfPost returned %@, expected %@", [news titleOfPost], _title);
    STAssertTrue([news post] == _post, @"news.post failed: news.post returned %@, expected %@", [news post], _post);    
    STAssertTrue([news subtitle] == _subtitle, @"news.subtitle failed: news.subtitle returned %@, expected %@", [news subtitle], _subtitle);    
    STAssertTrue([news author] == _author, @"news.author failed: news.author returned %@, expected %@", [news author], _author);    
    STAssertTrue([news date] == _date, @"news.date failed: news.date returned %@, expected %@", [news date], _date);    
    STAssertTrue([news time] == _time, @"news.time failed: news.time returned %@, expected %@", [news time], _time);
    STAssertTrue([news memberPost] == _memberPost, @"news.memberPost failed: news.memberPost returned %@, expected %@", [news memberPost], _memberPost);
    STAssertTrue([news timestamp] == _timestamp, @"news.timestamp failed: news.timestamp returned %@, expected %@", [news timestamp], _timestamp);
    
}

- (void)testMemberNewsPosts
{
    //all_posts : includes both standard and member posts.
    //regular_posts : includes only standard posts.
    NSMutableArray *all_posts = [[NSMutableArray alloc] init];
    NSMutableArray *regular_posts = [[NSMutableArray alloc] init];
    
    //set up all posts; for every number divisible by five, make it a member post.
    for(int i = 0; i < 100; i++){
        News *news = [[News alloc] init];
        NSString *_title = [NSString stringWithFormat:@"%d", i];
        NSString *_post = [NSString stringWithFormat:@"%d", i];
        NSString *_subtitle = [NSString stringWithFormat:@"%d", i];
        NSString *_author = [NSString stringWithFormat:@"%d", i];
        NSString *_date = [NSString stringWithFormat:@"%d", i];
        NSString *_time = [NSString stringWithFormat:@"%d", i];
        BOOL _memberPost = FALSE;
        if(i % 5 == 0){
            _memberPost = TRUE;
        }
        int _timestamp = i;
        
        news.titleOfPost = [NSString stringWithString:_title];
        news.post = [NSString stringWithString:_post];
        news.subtitle = [NSString stringWithString:_subtitle];
        news.author = [NSString stringWithString:_author];
        news.date = [NSString stringWithString:_date];
        news.time = [NSString stringWithString:_time];
        news.memberPost = _memberPost;
        news.timestamp = _timestamp;

        //if it is not a member post, add it to the regular_posts array.
        if(!_memberPost){
            [regular_posts addObject:news];
        }
        
        [all_posts addObject:news];
    }
        
    STAssertTrue(regular_posts.count != 0, @"regular_posts.count failed: regular_posts.count returned %d, expected 0", [regular_posts count]);
    STAssertTrue(all_posts.count != 0, @"all_posts.count failed: all_posts.count returned %d, expected 0", [all_posts count]);
    STAssertTrue(all_posts.count > regular_posts.count, @"all_posts.count > regular_posts.count failed: returned %@, expected TRUE", all_posts.count > regular_posts.count);
}

- (void)testExtractHTMLFromPostDefaultHTML
{
    NSString *string = @"<html><a href='blahblah'>hello</a></html>";
    NSString *expected_result = @"hello";
    NewsViewController *NVC = [[NewsViewController alloc] init];
    NSString *result = [NVC extractHTMLFromPost:string];
    
    STAssertTrue([result isEqualToString:expected_result], @"testExtractHTMLFromPostDefaultHTML failed");
}

- (void)testExtractHTMLFromPostNoGreaterThanSign
{
    NSString *string = @"<nogreaterthansignhere";
    NSString *expected_result = @"<nogreaterthansignhere";
    NewsViewController *NVC = [[NewsViewController alloc] init];
    NSString *result = [NVC extractHTMLFromPost:string];
    
    STAssertTrue([result isEqualToString:expected_result], @"testExtractHTMLFromPostNoGreaterThanSign failed");
}

- (void)testExtractHTMLFromPostNoLessThanSign
{
    NSString *string = @"nolessthansignhere>";
    NSString *expected_result = @"nolessthansignhere>";
    NewsViewController *NVC = [[NewsViewController alloc] init];
    NSString *result = [NVC extractHTMLFromPost:string];
    
    STAssertTrue([result isEqualToString:expected_result], @"testExtractHTMLFromPostNoLessThanSign failed");
}

- (void)testExtractHTMLFromPostMultipleSigns
{
    NSString *string = @"<><><><><><><><><><><><><><><><><><><><><><><>";
    NSString *expected_result = @"";
    NewsViewController *NVC = [[NewsViewController alloc] init];
    NSString *result = [NVC extractHTMLFromPost:string];
    
    STAssertTrue([result isEqualToString:expected_result], @"testExtractHTMLFromPostMultipleSigns failed");
}

- (void)testExtractHTMLFromPostNoEmbeddedTags
{
    NSString *string = @"<<<<<<<<<<>>>>>>>>>>";
    NSString *expected_result = @">>>>>>>>>";
    NewsViewController *NVC = [[NewsViewController alloc] init];
    NSString *result = [NVC extractHTMLFromPost:string];
    
    STAssertTrue([result isEqualToString:expected_result], @"testExtractHTMLFromPostNoEmbeddedTags failed");
}

- (void)testStripExcessEscapes1
{
    NSString *string = @"\r\n\r\n\r\n\r\n";
    NSString *expected_result = @"\r\n";
    NewsViewController *NVC = [[NewsViewController alloc] init];
    NSString *result = [NVC stripExcessEscapes:string];
    
    STAssertTrue([result isEqualToString:expected_result], @"testStripExcessEscapes1 failed");
}

- (void)testStripExcessEscapes2
{
    NSString *string = @"\r\r\r\r\r\r\r\r\r\r";
    NSString *expected_result = @"\r\n";
    NewsViewController *NVC = [[NewsViewController alloc] init];
    NSString *result = [NVC stripExcessEscapes:string];
    
    STAssertTrue([result isEqualToString:expected_result], @"testStripExcessEscapes2 failed");
}

- (void)testStripExcessEscapes3
{
    NSString *string = @"\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
    NSString *expected_result = @"\r\n";
    NewsViewController *NVC = [[NewsViewController alloc] init];
    NSString *result = [NVC stripExcessEscapes:string];
    
    STAssertTrue([result isEqualToString:expected_result], @"testStripExcessEscapes3 failed");
}

- (void)testStripExcessEscapes4
{
    NSString *string = @"";
    NSString *expected_result = @"";
    NewsViewController *NVC = [[NewsViewController alloc] init];
    NSString *result = [NVC stripExcessEscapes:string];
    
    STAssertTrue([result isEqualToString:expected_result], @"testStripExcessEscapes4 failed");
}

- (void)testStripExcessEscapes5
{
    NSString *string = @"First line.\r\n\r\n\r\nStart of the paragraph.\r\n\r\n";
    NSString *expected_result = @"First line.\r\nStart of the paragraph.\r\n";
    NewsViewController *NVC = [[NewsViewController alloc] init];
    NSString *result = [NVC stripExcessEscapes:string];
    
    STAssertTrue([result isEqualToString:expected_result], @"testStripExcessEscapes5 failed");
}

- (void)testStripExcessEscapes6
{
    NSString *string = @"First line.\r\nStart of the paragraph.\r\n";
    NSString *expected_result = @"First line.\r\nStart of the paragraph.\r\n";
    NewsViewController *NVC = [[NewsViewController alloc] init];
    NSString *result = [NVC stripExcessEscapes:string];
    
    STAssertTrue([result isEqualToString:expected_result], @"testStripExcessEscapes6 failed");
}

- (void)testUpdateTimestamp 
{
    NewsViewController *NVC = [[NewsViewController alloc] init];
    int expected_result = [[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]] intValue];
    [NVC updateTimestamp];
    
    STAssertTrue(expected_result == NVC.since, @"testUpdateTimestamp failed");
}

/***************************************************************************
 Roster Tests
 ***************************************************************************/

/***************************************************************************
 Media Tests
 ***************************************************************************/

/***************************************************************************
 Member Tests
 ***************************************************************************/

/***************************************************************************
 Info Tests
 ***************************************************************************/

/***************************************************************************
 API Tests
 ***************************************************************************/

- (void)testFetchNewsNoAPIArgument
{    
    NSString *API_Call = [NSString stringWithFormat:@"%@", TEXAS_DRUMS_API_NEWS];
    
    NSError *error = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
   
    NSString *result = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *expected_result = @"404 UNAUTHORIZED";
   
    STAssertTrue([result isEqualToString:expected_result], @"testFetchNewsNoAPIArgument failed: returned %@ as size, expected '404 UNAUTHORIZED'", result);
}


- (void)testFetchNewsNoArgument
{    
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@", TEXAS_DRUMS_API_NEWS, TEXAS_DRUMS_API_KEY];
    
    NSError *error = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
 
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:response error:&error];
    STAssertTrue([results count] != 0 && [results count] > 0, @"testFetchNewsNoArgument failed: returned %d as size, expected a positive non-zero value", [results count]);
}

- (void)testFetchNewsWithSinceArgument
{
    int since = 10000;
    
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&since=%d", TEXAS_DRUMS_API_NEWS, TEXAS_DRUMS_API_KEY, since];
    
    NSError *error = nil;   
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:response error:&error];
        STAssertTrue([results count] != 0 && [results count] > 0, @"testFetchNewsWithSinceArgument failed: returned %d as size, expected a positive non-zero value", [results count]);
}

- (void)testFetchNewsWithSinceArgumentNow
{
    int since = [[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]] intValue];;
    
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&since=%d", TEXAS_DRUMS_API_NEWS, TEXAS_DRUMS_API_KEY, since];
    
    NSError *error = nil;   
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:response error:&error];
    STAssertTrue([results count] == 0, @"testFetchNewsWithSinceArgumentNow failed: returned %d as size, expected 0", [results count]);
}

- (void)testFetchRosterNoAPIArgument
{    
    NSString *API_Call = [NSString stringWithFormat:@"%@", TEXAS_DRUMS_API_ROSTER];
    
    NSError *error = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSString *result = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *expected_result = @"404 UNAUTHORIZED";
    
    STAssertTrue([result isEqualToString:expected_result], @"testFetchRosterNoAPIArgument failed: returned %@ as size, expected '404 UNAUTHORIZED'", result);
}

- (void)testFetchRosterNoArgument
{
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@", TEXAS_DRUMS_API_ROSTER, TEXAS_DRUMS_API_KEY];
    
    NSError *error = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:response error:&error];
    STAssertTrue([results count] > 0, @"testFetchRosterNoArgument failed: returned %d as size, expected 0", [results count]);
}

- (void)testFetchRosterArgumentYearInvalid
{
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&year=%@", TEXAS_DRUMS_API_ROSTER, TEXAS_DRUMS_API_KEY, @"1-2"];
    
    NSError *error = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSString *result = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *expected_result = @"404 NOT FOUND";
    
    STAssertTrue([result isEqualToString:expected_result], @"testFetchRosterNoAPIArgument failed: returned %@ as size, expected '404 NOT FOUND'", result);
}

@end
