//
//  NewsViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "NewsViewController.h"
#import "TexasDrumsAppDelegate.h"
#import "Common.h"
#import "News.h"
#import "NewsPostView.h"
#import "TexasDrumsTableViewCell.h"
#import "TexasDrumsGetNews.h"

#import "CJSONDeserializer.h"
#import "RegexKitLite.h"
#import "GANTracker.h"
#import "SVProgressHUD.h"

#import "NSString+RegEx.h"
#import "UIFont+TexasDrums.h"
#import "UIColor+TexasDrums.h"

@implementation NewsViewController

@synthesize newsTable, posts, allposts, timestamp, reloadIndicator, refresh, loading, num_member_posts, received_data;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

- (void)viewDidLoad
{
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
    self.refresh = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(connect)] autorelease];
    
    self.navigationItem.rightBarButtonItem = refresh;
  
    // Begin fetching news from the server.
    [self connect];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.newsTable reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

#pragma mark - UI Methods

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont TexasDrumsBoldFontOfSize:20];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleView.textColor = [UIColor whiteColor]; 
        
        self.navigationItem.titleView = titleView;
        [titleView release];
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
    [self connect];
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

- (void)displayTable {
    float duration = 0.5f;
    [self.newsTable reloadData];
    [UIView beginAnimations:@"displayNewsTable" context:NULL];
    [UIView setAnimationDuration:duration];
    self.newsTable.alpha = 1.0f;
    [UIView commitAnimations];
}

#pragma mark - Data Methods

- (void)connect {
    [self hideRefreshButton];
    TexasDrumsGetNews *get = [[TexasDrumsGetNews alloc] initWithTimestamp:timestamp];
    get.delegate = self;
    [get startRequest];    
}

- (void)parseNewsData:(NSDictionary *)results {
    num_member_posts = 0;

    BOOL timestamp_updated = NO;

    // Iterate through the results and create News objects.
    for(NSDictionary *item in results){
        // NSLog(@"%@", item);
        
        News *post = [self createNewPost:item];
        
        // If we make it in this loop, then we know this post
        // to be the most recent timestamp.
        if(!timestamp_updated){
            self.timestamp = post.timestamp;
            timestamp_updated = YES;
            NSLog(@"Timestamp updated to %d.", post.timestamp);
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

#pragma mark - UITableView Data Source

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
    return 80;
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
    
    cell.textLabel.font = [UIFont TexasDrumsBoldFontOfSize:14];
    
    cell.detailTextLabel.numberOfLines = 3;
    
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


#pragma mark - UITableView Delegate Methods 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsPostView *NPV = [[NewsPostView alloc] initWithNibName:@"NewsPostView" bundle:[NSBundle mainBundle]];
    
    if(_Profile == nil){
        NPV.content = [[posts objectAtIndex:indexPath.row] post]; 
        NPV.post = [posts objectAtIndex:indexPath.row];
    }
    else {
        NPV.content = [[allposts objectAtIndex:indexPath.row] post]; 
        NPV.post = [allposts objectAtIndex:indexPath.row];
        
        if([[allposts objectAtIndex:indexPath.row] memberPost]){
            NPV.isMemberPost = TRUE;
        }
    }
    
    [self.navigationController pushViewController:NPV animated:YES];
    [NPV release];
}

#pragma mark - TexasDrumsRequest Delegate Methods

- (void)request:(TexasDrumsRequest *)request receivedData:(id)data {
    NSLog(@"Obtained news successfully.");
    
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:data error:&error];
    
    if([results count] > 0){
        NSLog(@"New news found. Parsing..");
        // Deserialize JSON results and parse them into News objects.
        [self parseNewsData:results];
    }
    
    [self dismissWithSuccess];
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    NSLog(@"request error: %@", error);
    
    // Show error message.
    [self dismissWithError];
}

@end
