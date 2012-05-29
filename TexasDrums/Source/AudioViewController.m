//
//  AudioViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 3/9/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "AudioViewController.h"
#import "GANTracker.h"
#import "Audio.h"
#import "Common.h"
#import "CJSONDeserializer.h"
#import "TexasDrumsTableViewCell.h"

#define CELL_CONTENT_WIDTH (320.0f)
#define CELL_CONTENT_MARGIN (10.0f)
#define _HEADER_HEIGHT_ (40)
#define FONT_SIZE (16.0f)

@implementation AudioViewController

@synthesize received_data, audioArray, audioTable, audioPlayer, mediaFinishedLoading, currentCell, pauseButton, playButton, indicator, status, yearArray, statusBar;

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
    [[GANTracker sharedTracker] trackPageview:@"Audio (AudioView)" withError:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    if([audioPlayer isPlaying]){
        [audioPlayer stop];
        [audioPlayer release];
        self.audioPlayer = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Audio"];

    // Set variables.
    self.mediaFinishedLoading = FALSE;
    self.pauseButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pausePlayer)] autorelease];
    self.playButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(resumePlayer)] autorelease];
    self.navigationItem.rightBarButtonItem = pauseButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // Initialize
    if(audioArray == nil){
        self.audioArray = [[[NSMutableArray alloc] init] autorelease];
    }
    if(yearArray == nil){
        self.yearArray = [[[NSMutableArray alloc] init] autorelease];
    }
    
    // Set instance variable properties
    self.audioTable.alpha = 0.0f;
    self.audioTable.backgroundColor = [UIColor clearColor];
    self.indicator.alpha = 1.0f;
    self.status.text = @"Loading...";
    self.status.alpha = 1.0f;
    
    [self fetchAudio];
}

- (void)fetchAudio {
    [self startConnection];
}

- (void)startConnection {
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&type=audio", TEXAS_DRUMS_API_MEDIA, TEXAS_DRUMS_API_KEY];
    NSLog(@"%@", API_Call);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLConnection *urlconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if(urlconnection) {
        received_data = [[NSMutableData data] retain];
    }
}

- (void)parseAudioData:(NSDictionary *)results {
    
    // Instantiate variables.
    NSString *current_year = @"";
    int i = 0;
    NSMutableArray *first_year = [[[NSMutableArray alloc] init] autorelease];
    [audioArray addObject:first_year];
    
    for(NSDictionary *item in results) {
        //NSLog(@"%@", item);
        
        // Create a new audio object.
        Audio *audio = [self createNewAudio:item];
        
        // If the current_year is empty, initialize it.
        if([current_year isEqualToString:@""]){
            current_year = audio.audioYear;
            [yearArray addObject:current_year];
        }

        // If the year is equal to the current_year, add it to the array.
        if([current_year isEqualToString:audio.audioYear]){
            [[audioArray objectAtIndex:i] addObject:audio];
        }
        // Otherwise, instantiate a new array and move the pointer.
        else {
            current_year = audio.audioYear;
            i++;
            
            NSMutableArray *this_year = [[[NSMutableArray alloc] init] autorelease];
            [audioArray addObject:this_year];
            [yearArray addObject:current_year];
            [[audioArray objectAtIndex:i] addObject:audio];
        }
    }
    
    // Any changes to UI must be done on main thread.
    [self performSelectorOnMainThread:@selector(displayTable) withObject:nil waitUntilDone:YES];
    
}

- (Audio *)createNewAudio:(NSDictionary *)item {
    Audio *audio = [[Audio alloc] init];
    audio.audioTitle = [item objectForKey:@"title"];
    // Need to encode this string with URL escapes (%20)
    audio.location = [[item objectForKey:@"location"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    audio.description = [item objectForKey:@"description"];
    audio.audioYear = [item objectForKey:@"year"];
    
    return [audio autorelease];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [yearArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[audioArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    //create a new view of size _HEADER_HEIGHT_, and place a label inside.
    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, _HEADER_HEIGHT_)] autorelease];
    UILabel *headerTitle = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)] autorelease];
    headerTitle.text = [yearArray objectAtIndex:section];
    headerTitle.textAlignment = UITextAlignmentCenter;
    headerTitle.textColor = [UIColor orangeColor];
    headerTitle.shadowOffset = CGSizeMake(0, 1);
    headerTitle.font = [UIFont fontWithName:@"Georgia-Bold" size:18];
    headerTitle.backgroundColor = [UIColor clearColor];
    
    UIImage *headerImage = [UIImage imageNamed:@"header.png"];
    UIImageView *headerImageView = [[[UIImageView alloc] initWithImage:headerImage] autorelease];
    headerImageView.frame = CGRectMake(0, 0, 320, 35);
    
    [containerView addSubview:headerImageView];
    [containerView addSubview:headerTitle];
    
	return containerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TexasDrumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TexasDrumsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:18];
    
    cell.textLabel.text = [[[audioArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] audioTitle];
    cell.detailTextLabel.text = [[[audioArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] description];
    
    return cell;
}

- (void)displayTable {
    float delay = 1.0f;
    [audioTable reloadData];
    [UIView beginAnimations:@"displayAudioTable" context:NULL];
    [UIView setAnimationDelay:delay];
    self.audioTable.alpha = 1.0f;
    self.status.alpha = 0.0f;
    self.indicator.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)disableTable {
    float delay = 1.0f;
    [audioTable reloadData];
    [UIView beginAnimations:@"disableAudioTable" context:NULL];
    [UIView setAnimationDuration:delay];
    self.audioTable.alpha = 0.5f;
    self.audioTable.userInteractionEnabled = NO;
    [UIView commitAnimations];    
}

- (void)enableTable {
    float delay = 1.0f;
    [audioTable reloadData];
    [UIView beginAnimations:@"enableAudioTable" context:NULL];
    [UIView setAnimationDuration:delay];
    self.audioTable.alpha = 1.0f;
    self.audioTable.userInteractionEnabled = YES;
    [UIView commitAnimations];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // If user taps the same cell, just stop the player and restart.
    if(self.currentCell == [tableView cellForRowAtIndexPath:indexPath]){
        if([audioPlayer isPlaying]){
            [audioPlayer stop];
            [audioPlayer setCurrentTime:0.0f];
        }
        
        [audioPlayer play];
        return;
    }
    
    self.navigationItem.prompt = @"Downloading...this may take a while.";
    [self disableTable];
    self.currentCell = [tableView cellForRowAtIndexPath:indexPath];
    
    self.navigationItem.rightBarButtonItem = self.pauseButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // Add an indicator to the accessory view of the cell to show that the media file is being loaded.
    UIActivityIndicatorView *cellIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [cellIndicator startAnimating];
    [currentCell setAccessoryView:cellIndicator];
    [cellIndicator release];
    
    // Not really useful, but we'll leave it here in case we do need it.
    self.mediaFinishedLoading = FALSE;
    
    [audioPlayer stop];
    [audioPlayer release];
    self.audioPlayer = nil;
    
    // Fetch the URL from the array.
    NSURL *url = [NSURL URLWithString:[[[audioArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] location]];
    if(DEBUG_MODE) NSLog(@"%@", url);
    
    // Spawn a background thread to load the media file.
    // Additionally, spawn another thread to remove the accessory view when the media has been loaded.
    NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
    NSInvocationOperation *loadData = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadDataFromURL:) object:url];
    [queue addOperation:loadData];
    
    [loadData release];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)loadDataFromURL:(NSURL *)url {
                             
    // Load contents from URL into data and initialize it within audioPlayer.
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSLog(@"Contents loaded.");
    self.mediaFinishedLoading = TRUE;
    
    if(audioPlayer == nil){
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
        self.audioPlayer.delegate = self;
    }
    
    audioPlayer.numberOfLoops = 0;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    [currentCell performSelectorOnMainThread:@selector(setAccessoryView:) withObject:nil waitUntilDone:NO];
    [self.navigationItem performSelectorOnMainThread:@selector(setPrompt:) withObject:nil waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(enableTable) withObject:nil waitUntilDone:NO];
    NSLog(@"Audio Player is playing.");
}

- (void)pausePlayer {
    if([audioPlayer isPlaying]){
        [audioPlayer pause];
        self.navigationItem.rightBarButtonItem = self.playButton;
    }
}

- (void)resumePlayer {
    if(![audioPlayer isPlaying]){
        [audioPlayer play];
        self.navigationItem.rightBarButtonItem = self.pauseButton;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.navigationItem.rightBarButtonItem = self.playButton;
    [audioPlayer setCurrentTime:0.0f];
}

// Some bugs to fix:
// Load right button bar item when media begins to play.
// What to do when the media is finished? Need to enable the play button again.

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
    if([audioArray count] == 0){
        NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:received_data error:&error];
        [self parseAudioData:results];
    }
    NSLog(@"Succeeded! Received %d bytes of data", [received_data length]);
    
    // release the connection, and the data object
    [connection release];
    [received_data release];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
