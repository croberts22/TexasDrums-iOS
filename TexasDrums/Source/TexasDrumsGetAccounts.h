//
//  TexasDrumsGetAccounts.h
//  TexasDrums
//
//  Created by Corey Roberts on 7/28/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "TexasDrumsRequest.h"

@interface TexasDrumsGetAccounts : TexasDrumsRequest {
    NSString *_username;
    NSString *_password;
    BOOL _getCurrentMembers;
}

- (id)initWithUsername:(NSString *)username andPassword:(NSString *)password getCurrentMembersOnly:(BOOL)getCurrentMembers;

@end
