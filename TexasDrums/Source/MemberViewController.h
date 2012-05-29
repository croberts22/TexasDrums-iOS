//
//  MemberViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface MemberViewController : UIViewController<NSURLConnectionDelegate> {
    IBOutlet UITableView *memberTable;
    IBOutlet UITextView *loginText;
    NSArray *membersOptions;
    NSMutableData *received_data;
}

@property (nonatomic, retain) UITableView *memberTable;
@property (nonatomic, retain) UITextView *loginText;
@property (nonatomic, retain) NSArray *membersOptions;
@property (nonatomic, retain) NSMutableData *received_data;

- (void)showMemberLoginScreen;
- (void)logout;
- (IBAction)logoutButtonPressed:(id)sender;

@end
