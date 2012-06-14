//
//  RosterViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Roster.h"
#import "RosterMember.h"


@interface RosterViewController : UIViewController<NSURLConnectionDelegate> {
    NSMutableArray *rosters;
    IBOutlet UITableView *rosterTable;
    UIBarButtonItem *refresh;
}

@property (nonatomic, retain) NSMutableArray *rosters;
@property (nonatomic, retain) UITableView *rosterTable;
@property (nonatomic, retain) UIBarButtonItem *refresh;

- (void)sortSections:(Roster *)roster;
- (void)fetchRosters;
- (NSString *)convertHTML:(NSString *)quote;
- (NSString *)parsePhoneNumber:(NSString *)number;

@end
