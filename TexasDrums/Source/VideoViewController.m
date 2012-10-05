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

@interface VideoViewController() {
    TexasDrumsGetVideos *getVideos;
}

@property (nonatomic, retain) TexasDrumsGetVideos *getVideos;

@end

@implementation VideoViewController

static NSMutableArray *videos = nil;
static NSMutableArray *years = nil;

@synthesize getVideos;
@synthesize videoTable;

#pragma mark - Memory Management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    self.getVideos.delegate = nil;
    [getVideos release], getVideos = nil;
    [videoTable release], videoTable = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Google Analytics
    [[GANTracker sharedTracker] trackPageview:[[self class] description] withError:nil];
    
    NSIndexPath *indexPath = [self.videoTable indexPathForSelectedRow];
    if(indexPath) {
        [self.videoTable deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    
    self.getVideos.delegate = nil;
    [self.getVideos cancelRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Videos"];
    
    // Set properties.
    self.videoTable.backgroundColor = [UIColor clearColor];
    
    // Allocate things as necessary.
    // If the static arrays are already allocated, there's no need
    // to fetch a request from the server.
    if(videos == nil && years == nil){
        self.videoTable.alpha = 0.0f;
        
        videos = [[NSMutableArray alloc] init];
        years = [[NSMutableArray alloc] init];

        [self connect];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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
    [self.videoTable reloadData];
    
    [UIView animateWithDuration:0.5f animations:^(void) {
        if([videos count] > 0){
            self.videoTable.alpha = 1.0f;
        }
        else {
            self.videoTable.alpha = 0.0f;
        }
    }];
}

#pragma mark - Data Methods

- (void)connect {
    [self hideRefreshButton];
    [SVProgressHUD showWithStatus:@"Loading..."];
    self.getVideos = [[TexasDrumsGetVideos alloc] init];
    self.getVideos.delegate = self;
    [self.getVideos startRequest];
}

- (void)parseVideoData:(NSDictionary *)results {
    
    // Instantiate variables.
    NSString *current_year = @"";
    int i = 0;
    NSMutableArray *first_year = [[[NSMutableArray alloc] init] autorelease];
    [videos addObject:first_year];
    
    for(NSDictionary *item in results) {
        //TDLog(@"%@", item);
        
        // Create a new video object.
        Video *video = [Video createNewVideo:item];
        
        // If the current_year is empty, initialize it.
        if([current_year isEqualToString:@""]){
            current_year = video.videoYear;
            [years addObject:current_year];
        }
        
        // If the year is equal to the current_year, add it to the array.
        if([current_year isEqualToString:video.videoYear]){
            [[videos objectAtIndex:i] addObject:video];
        }
        // Otherwise, instantiate a new array and move the pointer.
        else {
            current_year = video.videoYear;
            i++;
            
            NSMutableArray *this_year = [[[NSMutableArray alloc] init] autorelease];
            [videos addObject:this_year];
            [years addObject:current_year];
            [[videos objectAtIndex:i] addObject:video];
        }
    }
    
    [self displayTable];
    
}

#pragma mark - UITableView Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [years count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[videos objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = [years objectAtIndex:section];
    UIView *header = [UIView TexasDrumsVideoHeaderWithTitle:sectionTitle];
    
	return header;
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
    Video *this_video = [[videos objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = this_video.videoTitle;
    cell.detailTextLabel.text = this_video.description;

    // Asynchronously fetch the YouTube image. Use a thumbnail until the image is fetched. 
    [cell.imageView setImageWithURL:this_video.thumbnail placeholderImage:[UIImage imageNamed:@"ThumbnailSmall.png"]];
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Video *this_video = [[videos objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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
