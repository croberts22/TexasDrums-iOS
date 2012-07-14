//
//  StaffViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 1/13/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "TexasDrumsAPIConnection.h"

@interface StaffViewController : UIViewController<TexasDrumsAPIConnection> {
    IBOutlet UITableView *staffTable;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UILabel *status;
    NSMutableArray *staff;
    NSMutableData *received_data;
}

@property (nonatomic, retain) UITableView *staffTable;
@property (nonatomic, retain) NSMutableArray *staff;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UILabel *status;
@property (nonatomic, retain) NSMutableData *received_data;

- (void)fetchStaff;
- (void)parseStaffData:(NSDictionary *)results;

@end
