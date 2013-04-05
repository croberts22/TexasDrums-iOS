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
#import "CJSONDeserializer.h"

#import "AFJSONRequestOperation.h"
#import "TexasDrumsAppDelegate.h"

#import "NSString+RegEx.h"

@interface NewsViewController()

@property (nonatomic, assign) BOOL _reloading;

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

@implementation NewsViewController

@synthesize _reloading;
@synthesize newsTable, posts, allposts, timestamp, refresh, num_member_posts, status;

#pragma mark - Memory Management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        self.managedObjectContext = [((TexasDrumsAppDelegate *)[[UIApplication sharedApplication] delegate]) managedObjectContext];
    }
    return self;
}

- (void)dealloc {
    _refreshHeaderView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // If we're coming back from reading a news post, deselect the cell.
    NSIndexPath *indexPath = [self.newsTable indexPathForSelectedRow];
    if(indexPath) {
        [self.newsTable deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"News"];
    
    [self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;

    // Set properties.
    self.timestamp = 0;
//    self.newsTable.alpha = 0.0f;
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
	}
	
	// Update the last update date.
	[_refreshHeaderView refreshLastUpdatedDate];
    
    if(self.posts.count == 0) {
        [self hideRefreshButton];
        [self egoRefreshTableHeaderDidTriggerRefresh:_refreshHeaderView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.newsTable reloadData];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI Methods

- (void)refreshPressed {
    // We haven't stored anything in the posts array, so timestamp is 0.
    if(posts == nil || [posts count] == 0){
        timestamp = 0;
    }
    
    // Begin fetching news from the server.
    [self connect];
}

- (void)hideRefreshButton {
    self.navigationItem.rightBarButtonItem = nil;
//    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
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
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.texasdrums.com/api/2.0/news.php?apikey=LwtP6NB2Y0hooXVZj29fwceVfp93D&since=0"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        TDLog(@"Success!");
        
        for(NSDictionary *item in JSON) {
            News *news = [NSEntityDescription insertNewObjectForEntityForName:@"News" inManagedObjectContext:self.managedObjectContext];
            news.title = item[@"title"];
            news.content = item[@"content"];
            news.subtitle = [NSString extractHTML:news.content];
            news.subtitle = [NSString stripExcessEscapes:news.subtitle];
            news.timestamp = @([item[@"timestamp"] intValue]);
        }
        
        
        
        /*
         post.post = [item objectForKey:@"content"];
         post.postDate = [item objectForKey:@"date"];
         post.author = [item objectForKey:@"firstname"];
         post.time = [item objectForKey:@"time"];
         post.timestamp = [[item objectForKey:@"timestamp"] intValue];
         post.titleOfPost = [item objectForKey:@"title"];
         post.memberPost = [[item objectForKey:@"membernews"] boolValue];
         post.sticky = [[item objectForKey:@"sticky"] boolValue];
         post.subtitle = [NSString extractHTML:post.post];
         post.subtitle = [NSString stripExcessEscapes:post.subtitle];*/
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        TDLog(@"Failure.");
        
    }];
    
    [operation start];
}

- (void)parseNewsData:(NSDictionary *)results {
    num_member_posts = 0;

    BOOL timestamp_updated = NO;

    // Iterate through the results and create News objects.
    for(NSDictionary *item in results){
        if(DEBUG_MODE) TDLog(@"%@", item);
        
        //News *post = [News createNewPost:item];
        
        // If we make it in this loop, then we know this post
        // to be the most recent timestamp.
        if(!timestamp_updated){
//            self.timestamp = post.timestamp;
            timestamp_updated = YES;
//            TDLog(@"Timestamp updated to %d.", post.timestamp);
        }
        
//        if(!post.memberPost){
//            [posts addObject:post];
//        }
//        
//        [allposts addObject:post];
    }
    
    // Still need to sort the data in the event that we have new posts coming up through the refresh.
    [self sortTable];
    [self displayTable];
}

- (void)sortTable {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [allposts sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [posts sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    
    descriptor = [[NSSortDescriptor alloc] initWithKey:@"sticky" ascending:NO];
    [allposts sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [posts sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    TexasDrumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TexasDrumsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.textLabel.font = [UIFont TexasDrumsBoldFontOfSize:14];
        
        cell.detailTextLabel.numberOfLines = 3;
    }
    
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.imageView.image = nil;
    
    [self configureCell:cell atIndexPath:indexPath];
//    
//    // If logged in, set defaults and allow member posts to be displayed.
//    if([UserProfile sharedInstance].loggedIn){
//        cell.textLabel.text = [[allposts objectAtIndex:indexPath.row] titleOfPost];
//        cell.detailTextLabel.text = [[allposts objectAtIndex:indexPath.row] subtitle];
//
//        if([[allposts objectAtIndex:indexPath.row] memberPost]){
//            cell.textLabel.textColor = [UIColor TexasDrumsOrangeColor];
//            cell.detailTextLabel.textColor = [UIColor TexasDrumsOrangeColor];
//        }
//        
//        if([[allposts objectAtIndex:indexPath.row] sticky]){
//            cell.textLabel.textColor = [UIColor whiteColor];
//            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
//            cell.imageView.image = [UIImage stickyIcon];
//        }
//    }
//    else{
//        if([[posts objectAtIndex:indexPath.row] sticky]){
//            cell.textLabel.textColor = [UIColor whiteColor];
//            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
//            cell.imageView.image = [UIImage stickyIcon];
//        }
//        cell.textLabel.text = [[posts objectAtIndex:indexPath.row] titleOfPost];
//        cell.detailTextLabel.text = [[posts objectAtIndex:indexPath.row] subtitle];
//    }
    
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

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"News" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"News"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.newsTable beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.newsTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.newsTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.newsTable;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.newsTable endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    News *news = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if([news.sticky boolValue]) {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.imageView.image = [UIImage stickyIcon];
    }
    
    cell.textLabel.text = news.title;
    cell.detailTextLabel.text = news.subtitle;
}

@end
