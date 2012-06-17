//
//  RosterViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class Roster;
@class RosterMember;

@interface RosterViewController : UIViewController<NSURLConnectionDelegate> {
    NSMutableArray *rosters;
    IBOutlet UITableView *rosterTable;
    UIBarButtonItem *refresh;
}

@property (nonatomic, retain) NSMutableArray *rosters;
@property (nonatomic, retain) UITableView *rosterTable;
@property (nonatomic, retain) UIBarButtonItem *refresh;

- (void)refreshPressed;
- (void)hideRefreshButton;
- (void)dismissWithSuccess;
- (void)dismissWithError;
- (void)displayTable;

- (void)connect;
- (void)parseRosterData:(NSDictionary *)results;
- (RosterMember *)createNewRosterMember:(NSDictionary *)item;
- (NSString *)convertHTML:(NSString *)quote;
- (NSString *)parsePhoneNumber:(NSString *)number;
- (void)sortSections:(Roster *)roster;

@end
