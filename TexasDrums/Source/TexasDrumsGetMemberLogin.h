//
//  TexasDrumsGetMemberLogin.h
//  TexasDrums
//
//  Created by Corey Roberts on 7/13/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "TexasDrumsRequest.h"

@interface TexasDrumsGetMemberLogin : TexasDrumsRequest {
    NSString *_username;
    NSString *_password;
}

- (id)initWithUsername:(NSString *)username andPassword:(NSString *)password;

@end
