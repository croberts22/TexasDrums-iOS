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

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation NewsViewController

@synthesize newsTable, posts, allposts, since, reloadIndicator, refresh, loading, num_member_posts, received_data;

#define CELL_HEIGHT 10.0f
#define CELL_WIDTH 270.0f

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

    self.newsTable.alpha = 0.0f;
    
    self.refresh = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshPressed)] autorelease];
    
    self.navigationItem.rightBarButtonItem = refresh;
    
    //reload indicator replaces reload button (in button called loading) when reload button is pressed.
    self.reloadIndicator = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)] autorelease];

    [self.reloadIndicator sizeToFit];
    [self.reloadIndicator setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    
    self.loading = [[[UIBarButtonItem alloc] initWithCustomView:reloadIndicator] autorelease];
    
    self.newsTable.separatorColor = [UIColor darkGrayColor];
  
    [self performSelectorOnMainThread:@selector(hideRefreshButton) withObject:nil waitUntilDone:NO];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(refreshPressed) userInfo:nil repeats:NO];
}

- (void)refreshPressed {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //we haven't stored anything in the posts array, so since is 0.
    if(posts == nil || [posts count] == 0){
        since = 0;
    }
    else{
        [self updateTimestamp];
    }
    
    [self performSelectorOnMainThread:@selector(hideRefreshButton) withObject:nil waitUntilDone:NO];
    [self fetchNews];
}

- (void)hideRefreshButton {
    [reloadIndicator startAnimating];
    self.navigationItem.rightBarButtonItem = loading;
}

- (void)showRefreshButton {
    [reloadIndicator stopAnimating];
    self.navigationItem.rightBarButtonItem = refresh;
}

- (void)fetchNews {
    [self startConnection];
}

- (void)startConnection {
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&since=%d", TEXAS_DRUMS_API_NEWS, TEXAS_DRUMS_API_KEY, since];
    NSLog(@"%@", API_Call);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLConnection *urlconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if(urlconnection) {
        received_data = [[NSMutableData data] retain];
    }
}

- (void)parseNewsData:(NSDictionary *)results {
    num_member_posts = 0;
    if(posts == nil){
        posts = [[NSMutableArray alloc] init];
    }
    if(allposts == nil){
        allposts = [[NSMutableArray alloc] init];
    }
    
    for(NSDictionary *item in results){
        // NSLog(@"%@", item);
        News *post = [self createNewPost:item];
        
        if(!post.memberPost){
            [posts addObject:post];
        }
        
        [allposts addObject:post];
    }
    
    //news is already sorted through the API.
    //[self sortTable];
    
    //Any changes to UI must be done on main thread.
    [self performSelectorOnMainThread:@selector(displayTable) withObject:nil waitUntilDone:YES];

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


/* newsTable is already sorted through the API.
   ***DEPRECATED***
- (void)sortTable {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [posts sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [descriptor release];
}
*/

- (void)updateTimestamp{
    NSString *timestampString = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    self.since = [timestampString intValue];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[GANTracker sharedTracker] trackPageview:@"News (NewsView)" withError:nil];
    NSIndexPath *indexPath = [self.newsTable indexPathForSelectedRow];
    if(indexPath) {
        [self.newsTable deselectRowAtIndexPath:indexPath animated:YES];
    }
    //UIImage *bgImage = [UIImage imageNamed:@"UINavigationBar.png"];
    //[self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.newsTable reloadData];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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
            cell.textLabel.textColor = UIColorFromRGB(0xFF792A);
            cell.detailTextLabel.textColor = UIColorFromRGB(0xCE792A);
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
    [NSTimer scheduledTimerWithTimeInterval:delay+.25 target:self selector:@selector(showRefreshButton) userInfo:nil repeats:NO];
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

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    [received_data setLength:0];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to received_data.
    [received_data appendData:data];
}


- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    [received_data release];
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" 
                                                    message:[error localizedDescription] 
                                                   delegate:self 
                                          cancelButtonTitle:@":( Okay" 
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
    [self performSelectorOnMainThread:@selector(showRefreshButton) withObject:nil waitUntilDone:NO];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:received_data error:&error];
    
    [self parseNewsData:results];
    
    NSLog(@"Succeeded! Received %d bytes of data.", [received_data length]);
    
    // release the connection, and the data object
    [connection release];
    [received_data release];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
