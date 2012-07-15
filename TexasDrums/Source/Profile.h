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

@property (nonatomic, retain) int user_id;
@property (nonatomic, retain) NSString *firstname;
@property (nonatomic, retain) NSString *lastname;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
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
@property (nonatomic, retain) NSString *alphabet_first;
@property (nonatomic, retain) NSString *alphabet_last;

@end
