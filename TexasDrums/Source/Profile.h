//
//  Profile.h
//  TexasDrums
//
//  Created by Corey Roberts on 8/9/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

@interface Profile : NSObject {
    int user_id;
    NSString *firstname;
    NSString *lastname;
    NSString *username;
    NSString *password;
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
    NSString *alphabet_first;
    NSString *alphabet_last;    
}

@property (nonatomic, assign) int user_id;
@property (nonatomic, copy) NSString *firstname;
@property (nonatomic, copy) NSString *lastname;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
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
@property (nonatomic, copy) NSString *alphabet_first;
@property (nonatomic, copy) NSString *alphabet_last;

+ (Profile *)createNewProfile:(NSDictionary *)dictionary;
- (NSString *)fullName;

@end
