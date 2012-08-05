//
//  MemberListViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 8/4/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TexasDrumsAPIConnection.h"

@protocol MemberListViewControllerDelegate <NSObject>
- (void)memberListSelected:(NSArray *)selection;
@end

@interface MemberListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *memberList;
    NSMutableArray *currentSelection;
    
    id<MemberListViewControllerDelegate> delegate;
}

@property (nonatomic, retain) UITableView *memberList;
@property (nonatomic, retain) NSMutableArray *currentSelection;
@property (nonatomic, retain) id<MemberListViewControllerDelegate> delegate;

@end
