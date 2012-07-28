//
//  TexasDrumsGetAbout.m
//  TexasDrums
//
//  Created by Corey Roberts on 7/28/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "TexasDrumsGetAbout.h"

@implementation TexasDrumsGetAbout

#pragma mark -
#pragma mark Instance Methods

- (NSURL *)requestURL {
    NSString *server = [[TexasDrumsRequest TexasDrumsServerURL] absoluteString];
    
    NSString *request_URL = [NSString stringWithFormat:@"%@about.php?apikey=%@", server, [TexasDrumsRequest TexasDrumsAPIKey]];
    
    TDLog(@"Request: %@", request_URL);
    
    return [NSURL URLWithString:request_URL];
}

#pragma mark -
#pragma mark Startup / Tear down

- (id)init {
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
