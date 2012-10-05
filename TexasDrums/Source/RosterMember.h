//
//  RosterMember.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/24/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RosterMember : NSObject {
    NSString *firstname;
    NSString *nickname;
    NSString *lastname;
    NSString *fullname;
    NSString *instrument;
    NSString *classification;
    NSString *year;
    NSString *amajor;
    NSString *hometown;
    NSString *quote;
    int position;
    NSString *phone;
    NSString *email;
    int valid;
}

@property (nonatomic, copy) NSString *firstname;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *lastname;
@property (nonatomic, copy) NSString *fullname;
@property (nonatomic, copy) NSString *instrument;
@property (nonatomic, copy) NSString *classification;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *amajor;
@property (nonatomic, copy) NSString *hometown;
@property (nonatomic, copy) NSString *quote;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, assign) int position;
@property (nonatomic, assign) int valid;

+ (RosterMember *)createNewRosterMember:(NSDictionary *)item;

@end
