//
//  VideoViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 3/9/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "VideoViewController.h"
#import "Video.h"
#import "RegexKitLite.h"
#import "TexasDrumsWebViewController.h"
#import "TexasDrumsGetVideos.h"

#import "CJSONDeserializer.h"

@implementation VideoViewController

@synthesize videoArray, videoTable, yearArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [[GANTracker sharedTracker] trackPageview:@"Videos (VideoView)" withError:nil];
    NSIndexPath *indexPath = [self.videoTable indexPathForSelectedRow];
    if(indexPath) {
        [self.videoTable deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Videos"];
    
    // Allocate things as necessary.
    if(videoArray == nil){
        self.videoArray = [[[NSMutableArray alloc] init] autorelease];
    }
    if(yearArray == nil){
        self.yearArray = [[[NSMutableArray alloc] init] autorelease];
    }
    
    // Set properties.
    self.videoTable.alpha = 0.0f;
    self.videoTable.backgroundColor = [UIColor clearColor];
    
    [self connect];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    // Fetch videos from the server.
    [self connect];
}

- (void)hideRefreshButton {
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)dismissWithSuccess {
    self.navigationItem.rightBarButtonItem = nil;
    [SVProgressHUD dismiss];
}

- (void)dismissWithError {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshPressed)] autorelease];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [SVProgressHUD showErrorWithStatus:@"Could not fetch data."];
}

- (void)displayTable {
    float duration = 0.5f;
    [self.videoTable reloadData];
    [UIView beginAnimations:@"displayVideoTable" context:NULL];
    [UIView setAnimationDuration:duration];
    if([videoArray count] > 0){
        self.videoTable.alpha = 1.0f;
    }
    else {
        self.videoTable.alpha = 0.0f;
    }
    [UIView commitAnimations];
}

#pragma mark - Data Methods

- (void)connect {
    [self hideRefreshButton];
    [SVProgressHUD showWithStatus:@"Loading..."];
    TexasDrumsGetVideos *get = [[TexasDrumsGetVideos alloc] init];
    get.delegate = self;
    [get startRequest]; 
}

- (void)parseVideoData:(NSDictionary *)results {
    
    // Instantiate variables.
    NSString *current_year = @"";
    int i = 0;
    NSMutableArray *first_year = [[[NSMutableArray alloc] init] autorelease];
    [videoArray addObject:first_year];
    
    for(NSDictionary *item in results) {
        //TDLog(@"%@", item);
        
        // Create a new video object.
        Video *video = [Video createNewVideo:item];
        
        // If the current_year is empty, initialize it.
        if([current_year isEqualToString:@""]){
            current_year = video.videoYear;
            [yearArray addObject:current_year];
        }
        
        // If the year is equal to the current_year, add it to the array.
        if([current_year isEqualToString:video.videoYear]){
            [[videoArray objectAtIndex:i] addObject:video];
        }
        // Otherwise, instantiate a new array and move the pointer.
        else {
            current_year = video.videoYear;
            i++;
            
            NSMutableArray *this_year = [[[NSMutableArray alloc] init] autorelease];
            [videoArray addObject:this_year];
            [yearArray addObject:current_year];
            [[videoArray objectAtIndex:i] addObject:video];
        }
    }
    
    [self displayTable];
    
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [yearArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[videoArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  {
    // Create a custom header.
    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, STANDARD_HEADER_HEIGHT)] autorelease];
    UILabel *headerTitle = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 20)] autorelease];
    
    // Set header title properties.
    headerTitle.text = [yearArray objectAtIndex:section];
    headerTitle.textAlignment = UITextAlignmentCenter;
    headerTitle.textColor = [UIColor TexasDrumsOrangeColor];
    headerTitle.font = [UIFont TexasDrumsBoldFontOfSize:18];
    headerTitle.backgroundColor = [UIColor clearColor];
    headerTitle.shadowOffset = CGSizeMake(0, 1);
    
    // Set black gradient background behind header.
    UIImage *headerImage = [UIImage imageNamed:@"header.png"];
    UIImageView *headerImageView = [[[UIImageView alloc] initWithImage:headerImage] autorelease];
    headerImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    
    [containerView addSubview:headerImageView];
    [containerView addSubview:headerTitle];
    
	return containerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set cell properties.
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.font = [UIFont TexasDrumsBoldFontOfSize:14];
    cell.textLabel.textColor = [UIColor TexasDrumsGrayColor];
    
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.font = [UIFont TexasDrumsFontOfSize:12];
    
    cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uitableviewselection-orange-60.png"]] autorelease];
    
    // Find the correct video to display according to section and row.
    Video *this_video = [[videoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = this_video.videoTitle;
    cell.detailTextLabel.text = this_video.description;

    // Asynchronously fetch the YouTube image. Use a thumbnail until the image is fetched. 
    [cell.imageView setImageWithURL:this_video.thumbnail placeholderImage:[UIImage imageNamed:@"ThumbnailSmall.png"]];
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Video *this_video = [[videoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    TexasDrumsWebViewController *TDWVC = [[TexasDrumsWebViewController alloc] init];
    
    TDWVC.url = [NSURLRequest requestWithURL:[NSURL URLWithString:this_video.link]];
    
    // When going to the video, hide the tab bar.
    TDWVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:TDWVC animated:YES];
    [TDWVC release];
}

#pragma mark - TexasDrumsRequest Delegate Methods

- (void)request:(TexasDrumsRequest *)request receivedData:(id)data {
    TDLog(@"Obtained videos successfully.");
    
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:data error:&error];
    TDLog(@"%@", results);
    
    if([results count] > 0){
        [self parseVideoData:results];
    }
    
    [self dismissWithSuccess];
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    TDLog(@"Request error: %@", error);
    
    // Show refresh button and error message.
    [self dismissWithError];
}

@end
