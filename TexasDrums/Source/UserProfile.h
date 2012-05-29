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

@property (nonatomic, retain) NSString *firstname;
@property (nonatomic, retain) NSString *lastname;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *hash;
@property (nonatomic, retain) NSString *section;
@property (nonatomic, retain) NSString *years;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, assign) BOOL sl;
@property (nonatomic, assign) BOOL instructor;
@property (nonatomic, assign) BOOL admin;
@property (nonatomic, retain) NSString *phonenumber;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *birthday;
@property (nonatomic, assign) BOOL valid;
@property (nonatomic, retain) NSString *lastlogin;
@property (nonatomic, assign) BOOL paid;

@end
