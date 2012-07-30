//
//  TexasDrumsGetPaymentUpdate.m
//  TexasDrums
//
//  Created by Corey Roberts on 7/29/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "TexasDrumsGetPaymentUpdate.h"

@implementation TexasDrumsGetPaymentUpdate

#pragma mark -
#pragma mark Instance Methods

- (NSURL *)requestURL {
    NSString *server = [[TexasDrumsRequest TexasDrumsServerURL] absoluteString];
    
    NSString *request_URL = [NSString stringWithFormat:@"%@update_payment.php?apikey=%@&username=%@&password=%@&user=%@&paid=%@", server, [TexasDrumsRequest TexasDrumsAPIKey], _username, _password, _user, _paid];
    
    TDLog(@"Request: %@", request_URL);
    
    return [NSURL URLWithString:request_URL];
}

#pragma mark -
#pragma mark Startup / Tear down

- (id)initWithUsername:(NSString *)username andPassword:(NSString *)password andUser:(NSString *)user andPaid:(NSNumber *)paid {
    if((self = [super init])) {
        _username = username;
        _password = password;
        _user = user;
        _paid = paid;
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
