//
//  TexasDrumsGetAccounts.m
//  TexasDrums
//
//  Created by Corey Roberts on 7/28/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "TexasDrumsGetAccounts.h"

@implementation TexasDrumsGetAccounts

#pragma mark -
#pragma mark Instance Methods

- (NSURL *)requestURL {
    NSString *server = [[TexasDrumsRequest TexasDrumsServerURL] absoluteString];
    
    NSString *request_URL = [NSString stringWithFormat:@"%@accounts.php?apikey=%@&username=%@&password=%@&current_only=", server, [TexasDrumsRequest TexasDrumsAPIKey], _username, _password];
    
    if(_getCurrentMembers) {
        request_URL = [request_URL stringByAppendingString:@"YES"];
    }
    else {
        request_URL = [request_URL stringByAppendingString:@"NO"];
    }
    
    TDLog(@"Request: %@", request_URL);
    
    return [NSURL URLWithString:request_URL];
}

#pragma mark -
#pragma mark Startup / Tear down

- (id)initWithUsername:(NSString *)username andPassword:(NSString *)password getCurrentMembersOnly:(BOOL)getCurrentMembers {
    if((self = [super init])) {
        _username = username;
        _password = password;
        _getCurrentMembers = getCurrentMembers;
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
