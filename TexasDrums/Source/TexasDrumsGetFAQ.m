//
//  TexasDrumsGetFAQ.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/12/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "TexasDrumsGetFAQ.h"

@implementation TexasDrumsGetFAQ

#pragma mark -
#pragma mark Instance Methods

- (NSURL *)requestURL {
    NSString *server = [[TexasDrumsGetRequest TexasDrumsServerURL] absoluteString];
    
    NSString *request_URL = [NSString stringWithFormat:@"%@faq.php?apikey=%@", server, [TexasDrumsGetRequest TexasDrumsAPIKey]]; 
    NSLog(@"request: %@", request_URL);
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
#pragma mark TexasDrumsGetRequest Methods

- (void)startRequest {
    
    ASIHTTPRequest *ASIRequest = [ASIHTTPRequest requestWithURL:[self requestURL]];    
    ASIRequest.requestMethod = @"GET";	
    self.request = ASIRequest;
    
    [super startRequest];
}

@end
