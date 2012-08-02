//
//  UserProfile.h
//  TexasDrums
//
//  Created by Corey Roberts on 5/21/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject {
    NSString *firstname;
    NSString *lastname;
    NSString *username;
    NSString *hash;
    NSString *section;
    NSString *years;
    NSString *status;
    BOOL sl;
    BOOL instructor;
    BOOL admin;
    NSString *phonenumber;
    NSString *email;
    NSString *birthday;
    BOOL valid;
    NSString *lastlogin;
    BOOL paid;
}

@property (nonatomic, copy) NSString *firstname;
@property (nonatomic, copy) NSString *lastname;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *hash;
@property (nonatomic, copy) NSString *section;
@property (nonatomic, copy) NSString *years;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) BOOL sl;
@property (nonatomic, assign) BOOL instructor;
@property (nonatomic, assign) BOOL admin;
@property (nonatomic, copy) NSString *phonenumber;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, assign) BOOL valid;
@property (nonatomic, copy) NSString *lastlogin;
@property (nonatomic, assign) BOOL paid;

@end
