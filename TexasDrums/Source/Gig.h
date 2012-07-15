//
//  Gig.h
//  TexasDrums
//
//  Created by Corey Roberts on 7/14/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gig : NSObject {
    NSString *gig_name;
    int gig_id;
    NSString *location;
    NSString *description;
    int timestamp;
    NSString *timestamp_string;
    int snares_required;
    int tenors_required;
    int basses_required;
    int cymbals_required;
    int snares_current;
    int tenors_current;
    int basses_current;
    int cymbals_current;
    NSMutableArray *users;
}

@property (nonatomic, retain) NSString *gig_name;
@property (nonatomic, assign) int gig_id;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *timestamp_string;
@property (nonatomic, assign) int timestamp;
@property (nonatomic, assign) int snares_required;
@property (nonatomic, assign) int tenors_required;
@property (nonatomic, assign) int basses_required;
@property (nonatomic, assign) int cymbals_required;
@property (nonatomic, assign) int snares_current;
@property (nonatomic, assign) int tenors_current;
@property (nonatomic, assign) int basses_current;
@property (nonatomic, assign) int cymbals_current;
@property (nonatomic, retain) NSMutableArray *users;

- (void)convertTimestampToString;
- (NSString *)createRequiredText;
- (NSString *)createCurrentText;

@end
