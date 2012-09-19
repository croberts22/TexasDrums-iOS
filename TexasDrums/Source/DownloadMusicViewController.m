//
//  DownloadMusicViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 3/22/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "DownloadMusicViewController.h"
#import "MusicViewController.h"
#import "TexasDrumsWebViewController.h"
#import "TexasDrumsGroupedTableViewCell.h"
#import "CJSONDeserializer.h"
#import "Music.h"
#import "TexasDrumsGetMusic.h"

@interface DownloadMusicViewController() {
    TexasDrumsGetMusic *getMusic;
}

@property (nonatomic, retain) TexasDrumsGetMusic *getMusic;

@end

@implementation DownloadMusicViewController

@synthesize getMusic;
@synthesize musicTable, musicArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Memory Management

- (void)dealloc {
    self.getMusic.delegate = nil;
    [getMusic release], getMusic = nil;
    [musicTable release], musicTable = nil;
    [musicArray release], musicArray = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Google Analytics
    [[GANTracker sharedTracker] trackPageview:@"Download Music (DownloadMusicView)" withError:nil];
    
    NSIndexPath *indexPath = [self.musicTable indexPathForSelectedRow];
    if(indexPath) {
        [self.musicTable deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    [self.getMusic cancelRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Music"];
    
    // Allocate things as necessary.
    if(self.musicArray == nil){
        self.musicArray = [[NSMutableArray alloc] init];
    }
    
    // Set properties.
    self.musicTable.backgroundColor = [UIColor clearColor];
    self.musicTable.alpha = 0.0f;
    
    if([musicArray count] == 0) {
        [self connect];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
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
    // Fetch music from the server.
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
    [SVProgressHUD showErrorWithStatus:@"Could not fetch music."];
}

- (void)displayTable {
    [self.musicTable reloadData];
    [UIView animateWithDuration:0.5f animations:^{
        if([musicArray count] > 0){
            self.musicTable.alpha = 1.0f;
        }
        else {
            self.musicTable.alpha = 0.0f;
        }
    }];
}

#pragma mark - Data Methods

- (void)connect {
    [self hideRefreshButton];
    [SVProgressHUD showWithStatus:@"Loading..."];
    self.getMusic = [[TexasDrumsGetMusic alloc] initWithUsername:[UserProfile sharedInstance].username
                                                     andPassword:[UserProfile sharedInstance].hash];
    self.getMusic.delegate = self;
    [self.getMusic startRequest];
}

- (void)parseMusicData:(NSDictionary *)results {
    for(NSDictionary *item in results) {
        if(DEBUG_MODE) TDLog(@"%@", item);
        Music *music = [Music createNewMusic:item];
        [self.musicArray addObject:music];
    }
    
    [self displayTable];
}

#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.musicArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DEFAULT_ROW_HEIGHT;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [UIView TexasDrumsGroupedTableHeaderViewWithTitle:@"Select music:" andAlignment:UITextAlignmentCenter];
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    TexasDrumsGroupedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[[TexasDrumsGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

            cell.textLabel.font = [UIFont TexasDrumsBoldFontOfSize:16];
    }
    
    UIImage *background;
    UIImage *selected_background;
    
    // Since a cell's background views are not compatible with UIImageView,
    // set them both as UIImageView.
    cell.backgroundView = [[[UIImageView alloc] init] autorelease];
    cell.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];
    
    // Cell Background images.
    // TODO: Change the selected background image to something else.
    if(indexPath.row == 0){
        background = [UIImage imageNamed:@"top_table_cell.png"];
        selected_background = [UIImage imageNamed:@"top_table_cell.png"];
    }
    else if(indexPath.row == [musicArray count]-1){
        background = [UIImage imageNamed:@"bottom_table_cell.png"];
        selected_background = [UIImage imageNamed:@"bottom_table_cell.png"];
    }
    else {
        background = [UIImage imageNamed:@"table_cell.png"];
        selected_background = [UIImage imageNamed:@"table_cell.png"];
    }
    
    // Set the images.
    ((UIImageView *)cell.backgroundView).image = background;
    ((UIImageView *)cell.selectedBackgroundView).image = selected_background;
    
    Music *music = [self.musicArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = music.filename;
    
    return cell;
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TexasDrumsWebViewController *TDWVC = [[[TexasDrumsWebViewController alloc] init] autorelease];
    
    Music *music = [self.musicArray objectAtIndex:indexPath.row];
    NSString *url = music.location;
    
    TDWVC.url = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    TDWVC.the_title = music.filename;
    
    [self.navigationController pushViewController:TDWVC animated:YES];
}

#pragma mark - TexasDrumsRequest Delegate Methods

- (void)request:(TexasDrumsRequest *)request receivedData:(id)data {
    TDLog(@"Music request succeeded.");
    
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
            if([[results objectForKey:@"status"] isEqualToString:_403_UNKNOWN_ERROR]) {
                TDLog(@"No music found. Request returned: %@", [results objectForKey:@"status"]);
                [self dismissWithSuccess];
                return;
            }
        }
        
        TDLog(@"New music found. Parsing..");
        // Deserialize JSON results and parse them into Music objects.
        [self parseMusicData:results];
    }
    
    [self dismissWithSuccess];
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    TDLog(@"Music request error: %@", error);
    
    // Show error message.
    [self dismissWithError];
}


@end
