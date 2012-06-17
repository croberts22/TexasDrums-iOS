//
//  TexasDrumsGetRequest.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/3/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@protocol TexasDrumsGetRequestDelegate;

@interface TexasDrumsGetRequest : NSObject {
    ASIHTTPRequest *request;
    NSData *downloaded_data;
    
    NSUInteger retry_count;
    NSInteger response_code;
    
    id<TexasDrumsGetRequestDelegate> delegate;
    
    BOOL request_succeeded;
}

@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic, retain) NSData *downloaded_data;
@property (nonatomic, assign) NSInteger response_code;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign, readonly) BOOL request_succeeded;

+ (NSURL *)TexasDrumsServerURL;
+ (NSString *)TexasDrumsAPIVersion;
+ (NSString *)TexasDrumsAPIKey;
- (void)startRequest;
- (void)cancelRequest;
- (NSInteger)success_code;

@end

@protocol TexasDrumsGetRequestDelegate <NSObject>
@required
- (void)request:(TexasDrumsGetRequest *)request receivedData:(id)data;
- (void)request:(TexasDrumsGetRequest *)request failedWithError:(NSError *)error;

@end
