//
//  TexasDrumsRequest.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/3/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "TexasDrumsRequest.h"
#import "ASIDownloadCache.h"
#import "Common.h"

static NSURL *TexasDrumsServerURL;
static NSString *TexasDrumsAPIVersion;
static NSString *TexasDrumsAPIKey;
static int max_retry_count = 3;

@interface TexasDrumsRequest ()
@property (nonatomic, assign) BOOL request_succeeded;
@property (nonatomic, assign) NSUInteger retry_count;
@end

@implementation TexasDrumsRequest

@synthesize request = _request;
@synthesize downloaded_data = _downloaded_data;
@synthesize delegate = _delegate;
@synthesize retry_count = _retry_count;
@synthesize response_code = _response_code; 
@synthesize request_succeeded = _request_succeeded;

+ (void)initialize {
    if (self == [TexasDrumsRequest class]) {
        TexasDrumsAPIVersion = [[NSString alloc] initWithString:@"1.1"];
        TexasDrumsServerURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.texasdrums.com/api/%@/", TexasDrumsAPIVersion]];
        TexasDrumsAPIKey = [[NSString alloc] initWithString:@"LwtP6NB2Y0hooXVZj29fwceVfp93D"];
    }
}

- (id)init {
    self = [super init];
    if (self != nil) {
        request_succeeded = NO;
    }
    
    return self;
}

- (void)dealloc {
    [request cancel];
    
    [request release], request = nil;
    [downloaded_data release], downloaded_data = nil;
    
    [super dealloc];
}

# pragma mark -
# pragma mark Class Methods

+ (NSURL *)TexasDrumsServerURL {
    return [[TexasDrumsServerURL copy] autorelease];
}

+ (NSString *)TexasDrumsAPIVersion {
    return [[TexasDrumsAPIVersion copy] autorelease];
}

+ (NSString *)TexasDrumsAPIKey {
    return [[TexasDrumsAPIKey copy] autorelease];
}

# pragma mark -
# pragma mark Instance Methods

- (void)startRequest {
    [self.request setDownloadCache:[ASIDownloadCache sharedCache]];
    [self.request setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
    
    [self.request setDelegate:self];
    [self.request startAsynchronous];
}

- (void)cancelRequest {
    [self.request clearDelegatesAndCancel];
    self.request = nil;
}

- (NSInteger)success_code {
    return 200;
}

#pragma mark -
#pragma mark ASIHTTPRequest Methods

- (void)requestFailed:(ASIHTTPRequest *)request_ {
    NSError *error = [request_ error];
    if (((ASIConnectionFailureErrorType == [error code]) ||
         (ASIRequestTimedOutErrorType == [error code])) && (self.retry_count < max_retry_count)) {
        self.retry_count++;
        [self startRequest];
        TDLog(@"Failure type: %d. Failure count: %d", request.responseStatusCode, self.retry_count);
    }
    else {
        TDLog(@"Giving up on request. Failure count: %d", self.retry_count);
        
        self.request_succeeded = NO;
        
        [self.delegate request:self failedWithError:error];
        
        self.request = nil;
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request_ {
    self.response_code = request_.responseStatusCode;
    
    if(self.response_code == [self success_code]){
        self.request_succeeded = YES;
    }
    
    downloaded_data = [[[NSData alloc] initWithData:[request_ responseData]] autorelease];

    if(self.request_succeeded){
        switch (self.response_code){
            case 200:
                [self handle200Response];
                break;
            case 403:
                [self handle403Response];
                break;
            case 404:
                [self handle404Response];
                break;
            default:
                [self handleUnexpectedResponse];
                break;
        }
    }
    else {
        [self passErrorToDelegate];
    }
    
    self.request = nil;
}

- (void)handle200Response {
    if ([self.delegate respondsToSelector:@selector(request:receivedData:)]) {
        [self.delegate request:self receivedData:downloaded_data];
    }
}

- (void)handle403Response {
    [self passErrorToDelegate];
}

- (void)handle404Response {
    [self passErrorToDelegate];
}

- (void)handleUnexpectedResponse {
    TDLog(@"Unexpected HTTP response code: %u", self.response_code);
    NSAssert(NO, @"");
}

- (void)passErrorToDelegate {
    NSError *return_error = [NSError errorWithDomain:@"texasdrums.com" 
                                                code:self.response_code 
                                            userInfo:nil];
    
    [self.delegate request:self failedWithError:return_error];
}


@end
