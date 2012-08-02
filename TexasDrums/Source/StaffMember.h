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
    NSString *image_url;
    NSString *email;
    int sortfield;
}

@property (nonatomic, copy) NSString *first;
@property (nonatomic, copy) NSString *last;
@property (nonatomic, copy) NSString *fullname;
@property (nonatomic, copy) NSString *instrument;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *bio;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, assign) int sortfield;

- (id)init;
+ (StaffMember *)createNewStaffMember:(NSDictionary *)item;

@end
