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

#define _HEADER_HEIGHT_ (50)

@interface DownloadMusicViewController ()

@end

@implementation DownloadMusicViewController

@synthesize musicTable, musicArray, indicator, received_data, status;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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

- (void)viewWillAppear:(BOOL)animated {
    [[GANTracker sharedTracker] trackPageview:@"Download Music (DownloadMusicView)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Music"];
    if(musicArray == nil){
        self.musicArray = [[[NSMutableArray alloc] init] autorelease];
    }
    self.musicTable.backgroundColor = [UIColor clearColor];
    
    self.musicTable.alpha = 0.0f;
    self.status.alpha = 1.0f;
    self.indicator.alpha = 1.0f;
    [self fetchMusic];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)fetchMusic {
    [self startConnection];
}

- (void)startConnection {
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&username=%@&password=%@", TEXAS_DRUMS_API_MUSIC, TEXAS_DRUMS_API_KEY, _Profile.username, _Profile.password];
    TDLog(@"%@", API_Call);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLConnection *urlconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if(urlconnection) {
        received_data = [[NSMutableData data] retain];
    }
}

- (void)parseMusicData:(NSDictionary *)results {
    for(NSDictionary *item in results) {
        if(DEBUG_MODE) TDLog(@"%@", item);
        Music *music = [self createNewMusic:item];
        [musicArray addObject:music];
    }
    
    [self performSelectorOnMainThread:@selector(displayTable) withObject:nil waitUntilDone:YES];
}

- (Music *)createNewMusic:(NSDictionary *)item {
    Music *music = [[[Music alloc] init] autorelease];
    music.filename = [item objectForKey:@"name"];
    music.location = [[item objectForKey:@"location"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    music.instrument = [item objectForKey:@"instrument"];
    music.year = [[item objectForKey:@"year"] intValue];
    music.filetype = [item objectForKey:@"filetype"];
    music.status = [item objectForKey:@"status"];
    music.valid = [[item objectForKey:@"valid"] boolValue];
    
    return music;
}

- (void)displayTable {
    float delay = 1.0f;
    [musicTable reloadData];
    [UIView beginAnimations:@"displayNewsTable" context:NULL];
    [UIView setAnimationDelay:delay];
    self.musicTable.alpha = 1.0f;
    self.status.alpha = 0.0f;
    self.indicator.alpha = 0.0f;
    [UIView commitAnimations];
}


#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [musicArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TexasDrumsGroupedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[[TexasDrumsGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Overriding TexasDrumsGroupedTableViewCell properties.
    cell.textLabel.text = [[musicArray objectAtIndex:indexPath.row] filename];
    cell.textLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:16];
    
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
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return _HEADER_HEIGHT_;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [UIView TexasDrumsGroupedTableHeaderViewWithTitle:@"Select music:" andAlignment:UITextAlignmentCenter];
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.musicTable deselectRowAtIndexPath:indexPath animated:YES];
    TexasDrumsWebViewController *TDWVC = [[TexasDrumsWebViewController alloc] init];
    NSString *url = [[musicArray objectAtIndex:indexPath.row] location];
    TDWVC.url = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    TDWVC.the_title = [[musicArray objectAtIndex:indexPath.row] filename];
    [self.navigationController pushViewController:TDWVC animated:YES];
    [TDWVC release];
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
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
    TDLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" 
                                                    message:[error localizedDescription] 
                                                   delegate:self 
                                          cancelButtonTitle:@":( Okay" 
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
    [indicator stopAnimating];
    self.status.text = @"Nothing was found. Please try again later.";
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:received_data error:&error];
    
    [self parseMusicData:results];
    
    TDLog(@"Succeeded! Received %d bytes of data", [received_data length]);
    
    // release the connection, and the data object
    [connection release];
    [received_data release];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
