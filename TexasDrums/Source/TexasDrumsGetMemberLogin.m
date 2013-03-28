//
//  TexasDrumsGetMemberLogin.m
//  TexasDrums
//
//  Created by Corey Roberts on 7/13/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "TexasDrumsGetMemberLogin.h"

@implementation TexasDrumsGetMemberLogin

#pragma mark -
#pragma mark Instance Methods

- (NSURL *)requestURL {
    NSString *server = [[TexasDrumsRequest TexasDrumsServerURL] absoluteString];
    
    NSString *request_URL = [NSString stringWithFormat:@"%@login.php?apikey=%@&username=%@&password=%@&device=mobile", server, [TexasDrumsRequest TexasDrumsAPIKey], _username, _password]; 
    
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
