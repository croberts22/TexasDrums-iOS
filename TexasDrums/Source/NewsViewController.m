//
//  NewsViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "NewsViewController.h"
#import "News.h"
#import "NewsPostView.h"
#import "TexasDrumsTableViewCell.h"
#import "TexasDrumsGetNews.h"
#import "CJSONDeserializer.h"

@interface NewsViewController() {
    TexasDrumsGetNews *getNews;
}

@property (nonatomic, retain) TexasDrumsGetNews *getNews;
@property (nonatomic, assign) BOOL _reloading;

@end

@implementation NewsViewController

@synthesize getNews, _reloading;
@synthesize newsTable, posts, allposts, timestamp, refresh, num_member_posts, status;

#pragma mark - Memory Management

- (void)dealloc {
    self.getNews.delegate = nil;
    [getNews release], getNews = nil;
    [newsTable release], newsTable = nil;
    [posts release], posts = nil;
    [allposts release], allposts = nil;
    [refresh release], refresh = nil;
    [status release], status = nil;
    _refreshHeaderView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Google Analytics
    [[GANTracker sharedTracker] trackPageview:@"News (NewsView)" withError:nil];
    
    // If we're coming back from reading a news post, deselect the cell.
    NSIndexPath *indexPath = [self.newsTable indexPathForSelectedRow];
    if(indexPath) {
        [self.newsTable deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:@"News"];

    // Set properties.
    self.timestamp = 0;
    self.newsTable.alpha = 0.0f;
    self.newsTable.separatorColor = [UIColor darkGrayColor];
    
    // Allocate things as necessary.
    if(posts == nil){
        posts = [[NSMutableArray alloc] init];
    }
    if(allposts == nil){
        allposts = [[NSMutableArray alloc] init];
    }
    
    // Create refresh button.
    self.refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshPressed)];
    self.status.alpha = 0.0f;
    self.status.text = @"We were unable to load the news for you! Tap the refresh button or try again later.";
    self.status.textColor = [UIColor TexasDrumsGrayColor];
    
    // Create the 'Pull to Refresh' view.
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.newsTable.bounds.size.height, self.view.frame.size.width, self.newsTable.bounds.size.height)];
		view.delegate = self;
		[self.newsTable addSubview:view];
		_refreshHeaderView = view;
		[view release];
	}
	
	// Update the last update date.
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.newsTable reloadData];
    
    if(self.posts.count == 0) {
        [self hideRefreshButton];
        [self egoRefreshTableHeaderDidTriggerRefresh:_refreshHeaderView];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI Methods

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [UILabel TexasDrumsNavigationBar];
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}

- (void)refreshPressed {
    // We haven't stored anything in the posts array, so timestamp is 0.
    if(posts == nil || [posts count] == 0){
        timestamp = 0;
    }
    
    // Begin fetching news from the server.
    [self hideRefreshButton];
    [self connect];
}

- (void)hideRefreshButton {
    self.navigationItem.rightBarButtonItem = nil;
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
}

- (void)dismissWithSuccess {
    [SVProgressHUD dismiss];
}

- (void)dismissWithError {
    [SVProgressHUD showErrorWithStatus:@"Could not fetch data."];
    
    if(self.posts.count == 0 && self.status.alpha < 1.0f) {
        self.navigationItem.rightBarButtonItem = refresh;
        [UIView animateWithDuration:0.5f animations:^{
            self.status.alpha = 1.0f;
        }];
    }
}

- (void)displayTable {
    [self.newsTable reloadData];
    [UIView animateWithDuration:0.5f animations:^{
        if(self.status.alpha != 0.0f) {
            self.status.alpha = 0.0f;
        }
        self.newsTable.alpha = 1.0f;
    } completion:^(BOOL finished){
        if(finished) {
            self.status.hidden = YES;
        }
    }];
    
    [self doneLoadingTableViewData];
}

#pragma mark - Data Methods

- (void)connect {
    TexasDrumsGetNews *get = [[TexasDrumsGetNews alloc] initWithTimestamp:timestamp];
    get.delegate = self;
    [get startRequest];    
}

- (void)parseNewsData:(NSDictionary *)results {
    num_member_posts = 0;

    BOOL timestamp_updated = NO;

    // Iterate through the results and create News objects.
    for(NSDictionary *item in results){
        if(DEBUG_MODE) TDLog(@"%@", item);
        
        News *post = [News createNewPost:item];
        
        // If we make it in this loop, then we know this post
        // to be the most recent timestamp.
        if(!timestamp_updated){
            self.timestamp = post.timestamp;
            timestamp_updated = YES;
            TDLog(@"Timestamp updated to %d.", post.timestamp);
        }
        
        if(!post.memberPost){
            [posts addObject:post];
        }
        
        [allposts addObject:post];
    }
    
    // Still need to sort the data in the event that we have new posts coming up through the refresh.
    [self sortTable];
    [self displayTable];
}

- (void)sortTable {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [allposts sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [posts sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [descriptor release];
    
    descriptor = [[NSSortDescriptor alloc] initWithKey:@"sticky" ascending:NO];
    [allposts sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [posts sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];    
    [descriptor release];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // If user logged in, show all posts. Otherwise, just regular posts.
    if([UserProfile sharedInstance].loggedIn) {
        return [allposts count];
    }
    else{
        return [posts count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    TexasDrumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TexasDrumsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
        cell.textLabel.font = [UIFont TexasDrumsBoldFontOfSize:14];
        
        cell.detailTextLabel.numberOfLines = 3;
    }
    
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.imageView.image = nil;
    
    // If logged in, set defaults and allow member posts to be displayed.
    if([UserProfile sharedInstance].loggedIn){
        cell.textLabel.text = [[allposts objectAtIndex:indexPath.row] titleOfPost];
        cell.detailTextLabel.text = [[allposts objectAtIndex:indexPath.row] subtitle];

        if([[allposts objectAtIndex:indexPath.row] memberPost]){
            cell.textLabel.textColor = [UIColor TexasDrumsOrangeColor];
            cell.detailTextLabel.textColor = [UIColor TexasDrumsOrangeColor];
        }
        
        if([[allposts objectAtIndex:indexPath.row] sticky]){
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.imageView.image = [UIImage imageNamed:@"star.png"];
        }
    }
    else{
        if([[posts objectAtIndex:indexPath.row] sticky]){
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.imageView.image = [UIImage imageNamed:@"star.png"];
        }
        cell.textLabel.text = [[posts objectAtIndex:indexPath.row] titleOfPost];
        cell.detailTextLabel.text = [[posts objectAtIndex:indexPath.row] subtitle];
    }
     
    return cell;
}

#pragma mark - UITableView Delegate Methods 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsPostView *NPV = [[NewsPostView alloc] initWithNibName:@"NewsPostView" bundle:[NSBundle mainBundle]];
    
    if([UserProfile sharedInstance].loggedIn) {
        NPV.content = [[allposts objectAtIndex:indexPath.row] post];
        NPV.post = [allposts objectAtIndex:indexPath.row];
    }
    else {
        NPV.content = [[posts objectAtIndex:indexPath.row] post];
        NPV.post = [posts objectAtIndex:indexPath.row];
        
        if([[allposts objectAtIndex:indexPath.row] memberPost]){
            NPV.isMemberPost = TRUE;
        }
    }
    
    [self.navigationController pushViewController:NPV animated:YES];
    [NPV release];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource {
	_reloading = YES;
}

- (void)doneLoadingTableViewData {
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.newsTable];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
	[self reloadTableViewDataSource];
    [self connect];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
	return [NSDate date];
}

#pragma mark - TexasDrumsRequest Delegate Methods

- (void)request:(TexasDrumsRequest *)request receivedData:(id)data {
    TDLog(@"News request succeeded.");
    
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:data error:&error];

    if([results count] > 0){
        // Check if the response is just a dictionary value of one.
        // This implies that the key value pair follows the format:
        // status -> 'message'
        // We use respondsToSelector since the API returns a dictionary
        // of length one for any status messages, but an array of 
        // dictionary responses for valid data. 
        // CJSONDeserializer interprets actual data as NSArrays.
        if([results respondsToSelector:@selector(objectForKey:)] ){
            if([[results objectForKey:@"status"] isEqualToString:_NEWS_API_NO_NEW_ARTICLES]) {
                TDLog(@"No news found. Request returned: %@", [results objectForKey:@"status"]);
                [self doneLoadingTableViewData];
                return;
            }
        }
        
        TDLog(@"New news found. Parsing..");
        // Deserialize JSON results and parse them into News objects.
        [self parseNewsData:results];
    }
    
    [self dismissWithSuccess];
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    TDLog(@"News request error: %@", error);
    
    // Show error message.
    [self dismissWithError];
    [self doneLoadingTableViewData];
}

@end
