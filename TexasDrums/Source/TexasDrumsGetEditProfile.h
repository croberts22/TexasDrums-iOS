//
//  TexasDrumsGetEditProfile.h
//  TexasDrums
//
//  Created by Corey Roberts on 7/25/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "TexasDrumsRequest.h"

@interface TexasDrumsGetEditProfile : TexasDrumsRequest {
    NSString *_username;
    NSString *_password;
    NSString *_firstName;
    NSString *_lastName;
    NSString *_updatedPassword;
    NSString *_phone;
    NSString *_birthday;
    NSString *_email;
}

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *updatedPassword;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *email;

- (id)initWithUsername:(NSString *)username andPassword:(NSString *)password 
         withFirstName:(NSString *)firstName andLastName:(NSString *)lastName
    andUpdatedPassword:(NSString *)updatedPassword andPhone:(NSString *)phone 
           andBirthday:(NSString *)birthday andEmail:(NSString *)email;

@end
