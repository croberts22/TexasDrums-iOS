//
//  NewsViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "NewsViewController.h"
#import "Common.h"
#import "CJSONDeserializer.h"
#import "News.h"
#import "NewsPostView.h"
#import "RegexKitLite.h"
#import "TexasDrumsAppDelegate.h"
#import "GANTracker.h"
#import "TexasDrumsTableViewCell.h"
#import "NSString+RegEx.h"
#import "UIColor+TexasDrums.h"
#import "TexasDrumsGetNews.h"
#import "SVProgressHUD.h"

@implementation NewsViewController

@synthesize newsTable, posts, allposts, since, reloadIndicator, refresh, loading, num_member_posts, received_data;

- (void)dealloc
{
    [posts release];
    [allposts release];
    [newsTable release];
    [reloadIndicator release];
    [refresh release];
    [loading release];
    [received_data release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont fontWithName:@"Georgia-Bold" size:20];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleView.textColor = [UIColor whiteColor]; 
        
        self.navigationItem.titleView = titleView;
        [titleView release];
    }
    titleView.text = title;
    [titleView sizeToFit];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:@"News"];

    since = 0;
    
    self.newsTable.alpha = 0.0f;
    
    self.refresh = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(connect)] autorelease];
    
    self.navigationItem.rightBarButtonItem = refresh;
    
    self.newsTable.separatorColor = [UIColor darkGrayColor];
  
    [self connect];
}

- (void)refreshPressed {
    //we haven't stored anything in the posts array, so since is 0.
    if(posts == nil || [posts count] == 0){
        since = 0;
    }
    
    [self connect];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Google Analytics
    [[GANTracker sharedTracker] trackPageview:@"News (NewsView)" withError:nil];
    
    // If we're coming back from reading a news post, deselect the cell.
    NSIndexPath *indexPath = [self.newsTable indexPathForSelectedRow];
    if(indexPath) {
        [self.newsTable deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    // changing UINavBar graphics
    //UIImage *bgImage = [UIImage imageNamed:@"UINavigationBar.png"];
    //[self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.newsTable reloadData];
}

- (void)connect {
    [self hideRefreshButton];
    TexasDrumsGetNews *get = [[TexasDrumsGetNews alloc] initWithTimestamp:since];
    get.delegate = self;
    [get startRequest];    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)hideRefreshButton {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
}

- (void)dismissWithSuccess {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [SVProgressHUD dismiss];
}

- (void)dismissWithError {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [SVProgressHUD showErrorWithStatus:@"Could not fetch data."];
}

- (void)parseNewsData:(NSDictionary *)results {
    num_member_posts = 0;
    if(posts == nil){
        posts = [[NSMutableArray alloc] init];
    }
    if(allposts == nil){
        allposts = [[NSMutableArray alloc] init];
    }
    
    BOOL timestamp_updated = NO;
    
    for(NSDictionary *item in results){
        // NSLog(@"%@", item);
        
        News *post = [self createNewPost:item];
        
        if(!timestamp_updated){
            self.since = post.timestamp;
            timestamp_updated = YES;
            NSLog(@"Timestamp updated to most recent post: %d", post.timestamp);
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

- (News *)createNewPost:(NSDictionary *)item {
    News *post = [[[News alloc] init] autorelease];
    post.post = [item objectForKey:@"content"];
    post.postDate = [item objectForKey:@"date"];
    post.author = [item objectForKey:@"firstname"];
    post.time = [item objectForKey:@"time"];
    post.timestamp = [[item objectForKey:@"timestamp"] intValue];
    post.titleOfPost = [item objectForKey:@"title"];
    post.memberPost = [[item objectForKey:@"membernews"] boolValue];

    post.subtitle = [NSString extractHTML:post.post];
    post.subtitle = [NSString stripExcessEscapes:post.subtitle];
    
    return post;
}

- (void)sortTable {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [allposts sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [posts sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [descriptor release];
}

- (void)updateTimestamp{
    NSString *timestampString = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    self.since = [timestampString intValue];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // If user logged in, show all posts. Otherwise, just regular posts.
    if(_Profile != nil){
        return [allposts count];
    }
    else{
        return [posts count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TexasDrumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TexasDrumsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    // If logged in, set defaults and allow member posts to be displayed.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(_Profile != nil && [defaults boolForKey:@"login_valid"]){
        cell.textLabel.text = [[allposts objectAtIndex:indexPath.row] titleOfPost];
        cell.detailTextLabel.text = [[allposts objectAtIndex:indexPath.row] subtitle];

        if([[allposts objectAtIndex:indexPath.row] memberPost]){
            cell.textLabel.textColor = [UIColor TexasDrumsOrangeColor];
            cell.detailTextLabel.textColor = [UIColor TexasDrumsOrangeColor];
        }
    }
    else{
        cell.textLabel.text = [[posts objectAtIndex:indexPath.row] titleOfPost];
        cell.detailTextLabel.text = [[posts objectAtIndex:indexPath.row] subtitle];
    }
     
    return cell;
}

- (void)displayTable {
    float delay = 1.0f;
    [newsTable reloadData];
    [UIView beginAnimations:@"displayNewsTable" context:NULL];
    [UIView setAnimationDelay:delay];
    self.newsTable.alpha = 1.0f;
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(dismissWithSuccess) userInfo:nil repeats:NO];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsPostView *newsPostViewController = [[NewsPostView alloc] initWithNibName:@"NewsPostView" bundle:[NSBundle mainBundle]];
    
    if(_Profile == nil){
        newsPostViewController.content = [[posts objectAtIndex:indexPath.row] post]; 
        newsPostViewController.post = [posts objectAtIndex:indexPath.row];
    }
    else {
        newsPostViewController.content = [[allposts objectAtIndex:indexPath.row] post]; 
        newsPostViewController.post = [allposts objectAtIndex:indexPath.row];
        if([[allposts objectAtIndex:indexPath.row] memberPost]){
            newsPostViewController.isMemberPost = TRUE;
        }
    }
    [self.navigationController pushViewController:newsPostViewController animated:YES];
    [newsPostViewController release];
}

#pragma mark -
#pragma mark TexasDrumsGetRequestDelegate Methods

- (void)request:(TexasDrumsGetRequest *)request receivedData:(id)data {
    NSLog(@"Obtained news successfully.");
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:data error:&error];
    [self parseNewsData:results];
}

- (void)request:(TexasDrumsGetRequest *)request failedWithError:(NSError *)error {
    NSLog(@"request error: %@", error);
    // Show error message?
    [self dismissWithError];
}

@end
