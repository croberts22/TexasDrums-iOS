//
//  RosterMember.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/24/11.
//  Copyright 2011 University of Texas at Austin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Roster.h"


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

@property (nonatomic, retain) NSString *firstname;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *lastname;
@property (nonatomic, retain) NSString *fullname;
@property (nonatomic, retain) NSString *instrument;
@property (nonatomic, retain) NSString *classification;
@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSString *amajor;
@property (nonatomic, retain) NSString *hometown;
@property (nonatomic, retain) NSString *quote;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *email;
@property (nonatomic) int position;
@property (nonatomic) int valid;

@end
