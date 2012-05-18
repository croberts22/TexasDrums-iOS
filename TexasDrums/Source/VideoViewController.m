//
//  VideoViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 3/9/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import "VideoViewController.h"
#import "GANTracker.h"
#import "Video.h"
#import "UIImageView+WebCache.h"
#import "RegexKitLite.h"
#import "TexasDrumsWebViewController.h"
#import "NSString+RegEx.h"

#define CELL_CONTENT_WIDTH (320.0f)
#define CELL_CONTENT_MARGIN (10.0f)
#define _HEADER_HEIGHT_ (40)
#define FONT_SIZE (16.0f)

@implementation VideoViewController

@synthesize videoArray, videoTable, indicator, status, received_data, yearArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)viewWillAppear:(BOOL)animated {
    [[GANTracker sharedTracker] trackPageview:@"Videos (VideoView)" withError:nil];
    NSIndexPath *indexPath = [self.videoTable indexPathForSelectedRow];
    if(indexPath) {
        [self.videoTable deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Videos"];
    
    // Initialize
    if(videoArray == nil){
        self.videoArray = [[[NSMutableArray alloc] init] autorelease];
    }
    if(yearArray == nil){
        self.yearArray = [[[NSMutableArray alloc] init] autorelease];
    }
    
    // Set instance variable properties
    self.videoTable.alpha = 0.0f;
    self.videoTable.backgroundColor = [UIColor clearColor];
    self.indicator.alpha = 1.0f;
    self.status.text = @"Loading...";
    self.status.alpha = 1.0f;
    
    [self fetchVideo];
}

- (void)fetchVideo {
    [self startConnection];
}

- (void)startConnection {
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&type=video", TEXAS_DRUMS_API_MEDIA, TEXAS_DRUMS_API_KEY];
    NSLog(@"%@", API_Call);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLConnection *urlconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if(urlconnection) {
        received_data = [[NSMutableData data] retain];
    }
}

- (void)parseVideoData:(NSDictionary *)results {
    
    // Instantiate variables.
    NSString *current_year = @"";
    int i = 0;
    NSMutableArray *first_year = [[[NSMutableArray alloc] init] autorelease];
    [videoArray addObject:first_year];
    
    for(NSDictionary *item in results) {
        //NSLog(@"%@", item);
        
        // Create a new video object.
        Video *video = [self createNewVideo:item];
        
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
    
    // Any changes to UI must be done on main thread.
    [self performSelectorOnMainThread:@selector(displayTable) withObject:nil waitUntilDone:YES];
    
}

- (Video *)createNewVideo:(NSDictionary *)item {
    
    Video *video = [[Video alloc] init];
    video.videoTitle = [item objectForKey:@"title"];
    video.type = [item objectForKey:@"videotype"];
    video.link = [item objectForKey:@"link"];
    video.videoID = [item objectForKey:@"videoid"];
    video.description = [item objectForKey:@"description"];
    video.description = [NSString extractHTML:video.description];
    video.description = [NSString stripExcessEscapes:video.description];
    video.videoYear = [item objectForKey:@"year"];
    video.videoDate = [item objectForKey:@"date"];
    video.time = [item objectForKey:@"time"];
    video.timestamp = [[item objectForKey:@"timestamp"] intValue];
    video.valid = [[item objectForKey:@"valid"] boolValue];
    video.thumbnail = [self createThumbnailURL:video.videoID];
    
    return [video autorelease];
}
                       
- (NSURL *)createThumbnailURL:(NSString *)videoID {
    NSString *string = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/hqdefault.jpg", videoID];
    NSURL *url = [[NSURL alloc] initWithString:string];
    
    return [url autorelease];
}


- (void)displayTable {
    float delay = 1.0f;
    [videoTable reloadData];
    [UIView beginAnimations:@"displayVideoTable" context:NULL];
    [UIView setAnimationDelay:delay];
    self.videoTable.alpha = 1.0f;
    self.status.alpha = 0.0f;
    self.indicator.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [yearArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[videoArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    //create a new view of size _HEADER_HEIGHT_, and place a label inside.
    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, _HEADER_HEIGHT_)] autorelease];
    UILabel *headerTitle = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 20)] autorelease];
    headerTitle.text = [yearArray objectAtIndex:section];
    headerTitle.textAlignment = UITextAlignmentCenter;
    headerTitle.textColor = [UIColor orangeColor];
    headerTitle.shadowOffset = CGSizeMake(0, 1);
    headerTitle.font = [UIFont fontWithName:@"Georgia-Bold" size:18];
    headerTitle.backgroundColor = [UIColor clearColor];
    
    UIImage *headerImage = [UIImage imageNamed:@"header.png"];
    UIImageView *headerImageView = [[[UIImageView alloc] initWithImage:headerImage] autorelease];
    headerImageView.frame = CGRectMake(0, 0, 320, 30);
    
    [containerView addSubview:headerImageView];
    [containerView addSubview:headerTitle];
    
	return containerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:14];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Georgia" size:12];
    
    cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uitableviewselection-orange-60.png"]] autorelease];
    
    // Find the correct video to display according to section and row.
    Video *this_video = [[videoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = this_video.videoTitle;
    cell.detailTextLabel.text = this_video.description;

    // Asynchronously fetch the YouTube image; in the mean time, use a thumbnail
    // until the image is fetched.
    [cell.imageView setImageWithURL:this_video.thumbnail placeholderImage:[UIImage imageNamed:@"ThumbnailSmall.png"]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Video *this_video = [[videoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    TexasDrumsWebViewController *TDWVC = [[TexasDrumsWebViewController alloc] init];
    TDWVC.url = [NSURLRequest requestWithURL:[NSURL URLWithString:this_video.link]];
    TDWVC.hidesBottomBarWhenPushed = YES;
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
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    if([videoArray count] == 0){
        NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:received_data error:&error];
        [self parseVideoData:results];
    }
    NSLog(@"Succeeded! Received %d bytes of data", [received_data length]);
    
    // release the connection, and the data object
    [connection release];
    [received_data release];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
