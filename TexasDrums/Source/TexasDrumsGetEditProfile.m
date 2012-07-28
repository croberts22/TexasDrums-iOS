//
//  TexasDrumsGetEditProfile.m
//  TexasDrums
//
//  Created by Corey Roberts on 7/25/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "TexasDrumsGetEditProfile.h"

@implementation TexasDrumsGetEditProfile

@synthesize username = _username;
@synthesize password = _password;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize updatedPassword = _updatedPassword;
@synthesize phone = _phone;
@synthesize birthday = _birthday;
@synthesize email = _email;

#pragma mark -
#pragma mark Instance Methods

- (NSURL *)requestURL {
    NSString *server = [[TexasDrumsRequest TexasDrumsServerURL] absoluteString];
    
    NSString *request_URL = [NSString stringWithFormat:@"%@edit_profile.php?apikey=%@&username=%@&password=%@", server, [TexasDrumsRequest TexasDrumsAPIKey], _username, _password]; 
    
    if(_firstName != nil) {
        request_URL = [NSString stringWithFormat:@"%@&firstname=%@", request_URL, _firstName];
    }
    
    if(_lastName != nil) {
        request_URL = [NSString stringWithFormat:@"%@&lastname=%@", request_URL, _lastName];
    }

    if(_updatedPassword != nil) {
        request_URL = [NSString stringWithFormat:@"%@&new_password=%@", request_URL, _updatedPassword];
    }
    
    if(_phone != nil) {
        request_URL = [NSString stringWithFormat:@"%@&phone=%@", request_URL, _phone];
    }
    
    if(_birthday != nil) {
        request_URL = [NSString stringWithFormat:@"%@&birthday=%@", request_URL, _birthday];
    }
    
    if(_email != nil) {
        request_URL = [NSString stringWithFormat:@"%@&email=%@", request_URL, _email];
    }
    
    TDLog(@"Request: %@", request_URL);
    
    return [NSURL URLWithString:request_URL];
}

#pragma mark -
#pragma mark Startup / Tear down

- (id)initWithUsername:(NSString *)username andPassword:(NSString *)password withFirstName:(NSString *)firstName andLastName:(NSString *)lastName andUpdatedPassword:(NSString *)updatedPassword andPhone:(NSString *)phone andBirthday:(NSString *)birthday andEmail:(NSString *)email {
    if((self = [super init])) {
        _username = username;
        _password = password;
        _firstName = firstName;
        _lastName = lastName;
        _updatedPassword = updatedPassword;
        _phone = phone;
        _birthday = birthday;
        _email = email;
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
