//
//  MemberListViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 8/4/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TexasDrumsAPIConnection.h"

@interface MemberListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *memberList;
    NSMutableArray *currentSelection;
}

@property (nonatomic, retain) UITableView *memberList;
@property (nonatomic, retain) NSMutableArray *currentSelection;

@end
