//
//  NewsViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "News.h"

@interface NewsViewController : UIViewController<NSURLConnectionDelegate> {
    IBOutlet UITableView *newsTable;
    NSMutableArray *posts;
    NSMutableArray *allposts;
    int since;
    int num_member_posts;
    UIActivityIndicatorView *reloadIndicator;
    UIBarButtonItem *refresh;
    UIBarButtonItem *loading;
    NSMutableData *received_data;
}

@property (nonatomic, retain) UITableView *newsTable;
@property (nonatomic, retain) NSMutableArray *posts;
@property (nonatomic, retain) NSMutableArray *allposts;
@property (nonatomic) int since;
@property (nonatomic) int num_member_posts;
@property (nonatomic, retain) UIActivityIndicatorView *reloadIndicator;
@property (nonatomic, retain) UIBarButtonItem *refresh;
@property (nonatomic, retain) UIBarButtonItem *loading;
@property (nonatomic, retain) NSMutableData *received_data;

//overridden
- (void)setTitle:(NSString *)title;
//custom
- (void)updateTimestamp;
- (void)fetchNews;
- (void)parseNewsData:(NSDictionary *)results;
//- (void)sortTable; //**DEPRECATED**//
- (void)hideRefreshButton;
- (void)showRefreshButton;
- (void)refreshPressed;
- (News *)createNewPost:(NSDictionary *)item;

@end
