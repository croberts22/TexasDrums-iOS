//
//  StaffMember.h
//  TexasDrums
//
//  Created by Corey Roberts on 1/19/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffMember : NSObject {
    NSString *first;
    NSString *last;
    NSString *fullname;
    NSString *instrument;
    NSString *year;
    NSString *bio;
    NSString *email;
    int sortfield;
}

@property (nonatomic, retain) NSString *first;
@property (nonatomic, retain) NSString *last;
@property (nonatomic, retain) NSString *fullname;
@property (nonatomic, retain) NSString *instrument;
@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSString *bio;
@property (nonatomic, retain) NSString *email;
@property (nonatomic) int sortfield;

@end
