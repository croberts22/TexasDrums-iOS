//
//  MemberViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TexasDrumsAPIConnection.h"

@class TexasDrumsAppDelegate;

typedef enum {
    kLogin,
    kLogout
} ButtonType;

@interface MemberViewController : TexasDrumsViewController<TexasDrumsAPIConnection, UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *memberTable;
    IBOutlet UIView *loginPrompt;
    NSArray *membersOptions;
    NSArray *adminOptions;
}

@property (nonatomic, retain) UITableView *memberTable;
@property (nonatomic, retain) UIView *loginPrompt;
@property (nonatomic, retain) NSArray *membersOptions;
@property (nonatomic, retain) NSArray *adminOptions;

@end
