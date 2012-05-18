//
//  RosterViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Roster.h"
#import "RosterMember.h"


@interface RosterViewController : UIViewController<NSURLConnectionDelegate> {
    NSMutableArray *rosters;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UILabel *status;
    IBOutlet UITableView *rosterTable;
    UIBarButtonItem *refresh;
    NSMutableData *received_data;
}

@property (nonatomic, retain) NSMutableArray *rosters;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UILabel *status;
@property (nonatomic, retain) UITableView *rosterTable;
@property (nonatomic, retain) UIBarButtonItem *refresh;
@property (nonatomic, retain) NSMutableData *received_data;

- (void)sortSections:(Roster *)roster;
- (void)fetchRosters;
- (NSString *)convertHTML:(NSString *)quote;
- (NSString *)parsePhoneNumber:(NSString *)number;

@end
