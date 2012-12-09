//
//  NewsViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TexasDrumsAPIConnection.h"
#import "EGORefreshTableHeaderView.h"
#import "TexasDrumsViewController.h"

@class News;

@interface NewsViewController : TexasDrumsViewController<TexasDrumsAPIConnection, EGORefreshTableHeaderDelegate, UITableViewDataSource, UITableViewDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    IBOutlet UITableView *newsTable;
    IBOutlet UILabel *status;
    NSMutableArray *posts;
    NSMutableArray *allposts;
    int timestamp;
    int num_member_posts;
    UIBarButtonItem *refresh;
}

@property (nonatomic, retain) UITableView *newsTable;
@property (nonatomic, retain) UILabel *status;
@property (nonatomic, retain) NSMutableArray *posts;
@property (nonatomic, retain) NSMutableArray *allposts;
@property (nonatomic, assign) int timestamp;
@property (nonatomic, assign) int num_member_posts;
@property (nonatomic, retain) UIBarButtonItem *refresh;

- (void)refreshPressed;
- (void)hideRefreshButton;
- (void)dismissWithSuccess;
- (void)dismissWithError;
- (void)displayTable;

- (void)connect;
- (void)parseNewsData:(NSDictionary *)results;
- (void)sortTable;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
