//
//  TexasDrumsAPIConnection.h
//  TexasDrums
//
//  Created by Corey Roberts on 5/21/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TexasDrumsRequest;

@protocol TexasDrumsAPIConnection <NSObject>

- (void)connect;

// SVProgressHUD Methods
- (void)dismissWithSuccess;
- (void)dismissWithError;

// TexasDrumsRequestDelegate Methods
- (void)request:(TexasDrumsRequest *)request receivedData:(id)data;
- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error;

@end
