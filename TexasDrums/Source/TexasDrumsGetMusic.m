//
//  TexasDrumsGetMusic.m
//  TexasDrums
//
//  Created by Corey Roberts on 7/28/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "TexasDrumsGetMusic.h"

@implementation TexasDrumsGetMusic

#pragma mark -
#pragma mark Instance Methods

- (NSURL *)requestURL {
    NSString *server = [[TexasDrumsRequest TexasDrumsServerURL] absoluteString];
    
    NSString *request_URL = [NSString stringWithFormat:@"%@music.php?apikey=%@&username=%@&password=%@", server, [TexasDrumsRequest TexasDrumsAPIKey], _username, _password];
    
    TDLog(@"Request: %@", request_URL);
    
    return [NSURL URLWithString:request_URL];
}

#pragma mark -
#pragma mark Startup / Tear down

- (id)initWithUsername:(NSString *)username andPassword:(NSString *)password {
    if((self = [super init])) {
        _username = username;
        _password = password;
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
