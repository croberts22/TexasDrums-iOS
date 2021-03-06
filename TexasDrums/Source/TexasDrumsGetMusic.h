//
//  TexasDrumsGetMusic.h
//  TexasDrums
//
//  Created by Corey Roberts on 7/28/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "TexasDrumsRequest.h"

@interface TexasDrumsGetMusic : TexasDrumsRequest {
    NSString *_username;
    NSString *_password;
}

- (id)initWithUsername:(NSString *)username andPassword:(NSString *)password;

@end
