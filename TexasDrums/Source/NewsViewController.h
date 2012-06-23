//
//  NewsViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TexasDrumsTable.h"
#import "TexasDrumsAPIConnection.h"

@class News;

@interface NewsViewController : UIViewController<TexasDrumsTable, TexasDrumsAPIConnection> {
    IBOutlet UITableView *newsTable;
    NSMutableArray *posts;
    NSMutableArray *allposts;
    int timestamp;
    int num_member_posts;
    UIActivityIndicatorView *reloadIndicator;
    UIBarButtonItem *refresh;
    UIBarButtonItem *loading;
    NSMutableData *received_data;
}

@property (nonatomic, retain) UITableView *newsTable;
@property (nonatomic, retain) NSMutableArray *posts;
@property (nonatomic, retain) NSMutableArray *allposts;
@property (nonatomic, assign) int timestamp;
@property (nonatomic, assign) int num_member_posts;
@property (nonatomic, retain) UIActivityIndicatorView *reloadIndicator;
@property (nonatomic, retain) UIBarButtonItem *refresh;
@property (nonatomic, retain) UIBarButtonItem *loading;
@property (nonatomic, retain) NSMutableData *received_data;

- (void)refreshPressed;
- (void)hideRefreshButton;
- (void)dismissWithSuccess;
- (void)dismissWithError;
- (void)displayTable;

- (void)connect;
- (void)parseNewsData:(NSDictionary *)results;
- (News *)createNewPost:(NSDictionary *)item;
- (void)sortTable;

@end
