//
//  TexasDrumsGetNews.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/3/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "TexasDrumsGetNews.h"

@implementation TexasDrumsGetNews 

#pragma mark -
#pragma mark Instance Methods

- (NSURL *)requestURL {
    NSString *server = [[TexasDrumsRequest TexasDrumsServerURL] absoluteString];
    
    NSString *request_URL = [NSString stringWithFormat:@"%@news.php?apikey=%@&since=%d", server, [TexasDrumsRequest TexasDrumsAPIKey], _timestamp]; 
    
    TDLog(@"Request: %@", request_URL);
    
    return [NSURL URLWithString:request_URL];
}

#pragma mark -
#pragma mark Startup / Tear down

- (id)initWithTimestamp:(NSInteger)timestamp {
    
    if ((self = [super init])) {
        _timestamp = timestamp;
    }
    
    return self;
}

- (void)dealloc {
    [super cancelRequest];
    self.delegate = nil;
    
	[super dealloc];
}

#pragma mark -
#pragma mark TexasDrumsRequest Methods

- (void)startRequest {
    
    ASIHTTPRequest *ASIRequest = [ASIHTTPRequest requestWithURL:[self requestURL]];    
    ASIRequest.requestMethod = @"GET";	
    self.request = ASIRequest;

    [super startRequest];
}
                             

@end
