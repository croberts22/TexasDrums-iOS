//
//  MemberViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "TexasDrumsAPIConnection.h"

@class TexasDrumsAppDelegate;

typedef enum {
    kLogin,
    kLogout
} ButtonType;

@interface MemberViewController : UIViewController<TexasDrumsAPIConnection, NSURLConnectionDelegate> {
    IBOutlet UITableView *memberTable;
    IBOutlet UIView *loginPrompt;
    NSArray *membersOptions;
    NSArray *adminOptions;
    
    TexasDrumsAppDelegate *delegate;
}

@property (nonatomic, retain) UITableView *memberTable;
@property (nonatomic, retain) UIView *loginPrompt;
@property (nonatomic, retain) NSArray *membersOptions;
@property (nonatomic, retain) NSArray *adminOptions;
@property (nonatomic, retain) TexasDrumsAppDelegate *delegate;

- (void)setButton:(ButtonType)buttonType;
- (void)showMemberLoginScreen;
- (void)logoutButtonPressed;
- (void)destroyProfile;
- (void)logout;

@end
