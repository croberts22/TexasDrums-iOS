//
//  TexasDrumsGetPaymentUpdate.h
//  TexasDrums
//
//  Created by Corey Roberts on 7/29/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "TexasDrumsRequest.h"

@interface TexasDrumsGetPaymentUpdate : TexasDrumsRequest {
    NSString *_username;
    NSString *_password;
    NSString *_user;
    NSNumber *_paid;
}

- (id)initWithUsername:(NSString *)username andPassword:(NSString *)password andUser:(NSString *)user andPaid:(NSNumber *)paid;

@end
