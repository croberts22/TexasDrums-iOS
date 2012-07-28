//
//  StaffViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 1/13/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TexasDrumsAPIConnection.h"

@interface StaffViewController : UIViewController<TexasDrumsAPIConnection> {
    IBOutlet UITableView *staffTable;
    NSMutableArray *staff;
}

@property (nonatomic, retain) UITableView *staffTable;
@property (nonatomic, retain) NSMutableArray *staff;

- (void)displayTable;
- (void)parseStaffData:(NSDictionary *)results;

@end
