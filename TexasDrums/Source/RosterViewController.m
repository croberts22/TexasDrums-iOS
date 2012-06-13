//
//  RosterViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "RosterViewController.h"
#import "TexasDrumsAppDelegate.h"
#import "Common.h"
#import "Roster.h"
#import "RosterMember.h"
#import "SingleRosterViewController.h"
#import "TexasDrumsGroupedTableViewCell.h"
#import "CJSONDeserializer.h"
#import "RegexKitLite.h"
#import "GANTracker.h"
#import "TexasDrumsGetRosters.h"

@implementation RosterViewController

#define _HEADER_HEIGHT_ (50)

@synthesize rosters, indicator, rosterTable, received_data, status, refresh;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

#pragma mark - UI methods


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

- (void)setStatusText:(NSString *)text {
    self.status.text = text;
}

- (void)displayTable {
    float delay = 1.0f;
    [self.rosterTable reloadData];
    [UIView beginAnimations:@"displayRosterTable" context:NULL];
    if([rosters count] > 0){
        [UIView setAnimationDelay:delay];
        self.rosterTable.alpha = 1.0f;
        self.status.alpha = 0.0f;
        self.indicator.alpha = 0.0f;
    }
    else {
        [UIView setAnimationDelay:delay];
        self.rosterTable.alpha = 0.0f;
        self.status.alpha = 1.0f;
        self.indicator.alpha = 0.0f;
        [self setStatusText:@"Nothing was found. Please try again."];
    }
    [UIView commitAnimations];
    [self.indicator performSelector:@selector(stopAnimating) withObject:nil afterDelay:delay+.25];
}

- (void)hideRefreshButton {
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)showRefreshButton {
    self.navigationItem.rightBarButtonItem = refresh;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Roster"];
    
    self.refresh = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshPressed)] autorelease];
    
    self.navigationItem.rightBarButtonItem = refresh;
    
    self.rosterTable.alpha = 0.0f;
    self.status.alpha = 1.0f;
    self.rosterTable.backgroundColor = [UIColor clearColor];
    self.rosterTable.separatorColor = [UIColor clearColor];
    if(rosters == nil){
        rosters = [[NSMutableArray alloc] init];
    }
}

- (void)refreshPressed {
    [self hideRefreshButton];
    [self fetchRosters];
}

- (void)fetchRosters {
    self.indicator.alpha = 1.0f;
    [indicator startAnimating];
    [self setStatusText:@"Loading..."];
    [self hideRefreshButton];
    
    [self startConnection];
}

- (void)startConnection {
     NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&count=yes", TEXAS_DRUMS_API_ROSTER, TEXAS_DRUMS_API_KEY];
    NSLog(@"%@", API_Call);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLConnection *urlconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if(urlconnection) {
        received_data = [[NSMutableData data] retain];
    }
}

// this needs to be fixed for API 1.1
- (void)parseRosterData:(NSDictionary *)results {
    // result is nsdictionary 
    for(NSString *year in results){
        Roster *roster = [[Roster alloc] init];
        roster.snares = [[[NSMutableArray alloc] init] autorelease];
        roster.tenors = [[[NSMutableArray alloc] init] autorelease];
        roster.basses = [[[NSMutableArray alloc] init] autorelease];
        roster.cymbals = [[[NSMutableArray alloc] init] autorelease];
        roster.instructor = [[[NSMutableArray alloc] init] autorelease];
        roster.the_year = [NSString stringWithString:year];
        
        NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&year=%@", TEXAS_DRUMS_API_ROSTER, TEXAS_DRUMS_API_KEY, year];
        //NSLog(@"%@", API_Call);
        NSError *error = nil;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call]];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *roster_results = [[CJSONDeserializer deserializer] deserialize:response error:&error];

        for(NSDictionary *this_member in roster_results){
            RosterMember *member = [self createNewRosterMember:this_member];

            if([member.instrument isEqualToString:@"Snare"]){
                [roster.snares addObject:member];
            }
            else if([member.instrument isEqualToString:@"Tenors"]){
                [roster.tenors addObject:member];
            }
            else if([member.instrument isEqualToString:@"Bass"]){
                [roster.basses addObject:member];
            }
            else if([member.instrument isEqualToString:@"Cymbals"]){
                [roster.cymbals addObject:member];
            }
        }
        
        [self sortSections:roster];
        [rosters addObject:roster];
        [roster release];
    }
    [self performSelectorOnMainThread:@selector(displayTable) withObject:nil waitUntilDone:NO];
    if(DEBUG_MODE) NSLog(@"Roster table configured. Reloading...");

}

- (RosterMember *)createNewRosterMember:(NSDictionary *)item {
    RosterMember *member = [[[RosterMember alloc] init] autorelease];
    member.firstname = [item objectForKey:@"firstname"];
    member.nickname = [item objectForKey:@"nickname"];
    member.lastname = [item objectForKey:@"lastname"];
    member.fullname = [NSString stringWithFormat:@"%@ %@", member.firstname, member.lastname];
    member.instrument = [item objectForKey:@"instrument"];
    member.classification = [item objectForKey:@"classification"];
    member.year = [item objectForKey:@"year"];
    member.amajor = [item objectForKey:@"major"];
    member.hometown = [item objectForKey:@"hometown"];
    member.quote = [item objectForKey:@"quote"];
    member.quote = [self convertHTML:member.quote];
    member.position = [[item objectForKey:@"position"] intValue];
    member.phone = [item objectForKey:@"phone"];
    member.phone = [self parsePhoneNumber:member.phone];
    member.email = [item objectForKey:@"email"];
    member.valid = [[item objectForKey:@"valid"] intValue];
    
    if([member.email length] == 0){
        member.email = @"n/a";   
    }
    
    return member;
}

- (NSString *)convertHTML:(NSString *)quote {
    NSString *searchString = quote;
    NSString *regexString = @"<br>|<br />";
    NSString *replaceWithString = @"\r\n";
    NSString *replacedString = NULL;
    
    replacedString = [searchString stringByReplacingOccurrencesOfRegex:regexString withString:replaceWithString];
    
    //NSLog(@"replaced string: '%@'", replacedString);
    
    return replacedString;
}

- (NSString *)parsePhoneNumber:(NSString *)number {
    NSString *areacode;
    NSString *first;
    NSString *last;
    
    if([number length] == 10){
        areacode = [number substringWithRange:NSMakeRange(0, 3)];
        first = [number substringWithRange:NSMakeRange(3, 3)];
        last = [number substringWithRange:NSMakeRange(6, 4)];
        return [NSString stringWithFormat:@"%@-%@-%@", areacode, first, last];
    }
    else if([number length] == 7){
        first = [number substringWithRange:NSMakeRange(0, 3)];
        last = [number substringWithRange:NSMakeRange(3, 4)];
        return [NSString stringWithFormat:@"%@-%@", first, last];
    }
    else if([number length] <= 1){
        return @"n/a";
    }
    return number;
}

- (void)sortSections:(Roster *)roster {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:NO];
    [roster.snares sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];  
    [descriptor release];
    descriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
    [roster.basses sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [roster.tenors sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [roster.cymbals sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [descriptor release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[GANTracker sharedTracker] trackPageview:@"Roster (RosterView)" withError:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self connect];
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

- (void)connect {
    TexasDrumsGetRosters *get = [[TexasDrumsGetRosters alloc] init];
    get.delegate = self;
    [get startRequest]; 
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [rosters count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return _HEADER_HEIGHT_;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    
    //create a new view of size _HEADER_HEIGHT_, and place a label inside.
    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, _HEADER_HEIGHT_)] autorelease];
    UILabel *headerTitle = [[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 30)] autorelease];
    if([rosters count] > 0){
        headerTitle.text = @"Select a year:";
    }
    else {
        headerTitle.text = @"";
    }
    headerTitle.textAlignment = UITextAlignmentCenter;
    headerTitle.textColor = [UIColor orangeColor];
    //headerTitle.shadowColor = [UIColor darkGrayColor];
    headerTitle.shadowOffset = CGSizeMake(0, 1);
    headerTitle.font = [UIFont fontWithName:@"Georgia-Bold" size:18];
    headerTitle.backgroundColor = [UIColor clearColor];
    [containerView addSubview:headerTitle];
    
	return containerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TexasDrumsGroupedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TexasDrumsGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Overriding TexasDrumsGroupedTableViewCell properties.
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[rosters objectAtIndex:indexPath.row] the_year]];
    
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
    else if(indexPath.row == [rosters count]-1){
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.rosterTable deselectRowAtIndexPath:indexPath animated:YES];
    SingleRosterViewController *srvc = [[SingleRosterViewController alloc] initWithNibName:@"SingleRosterView" bundle:[NSBundle mainBundle]];
    srvc.snares = [NSArray arrayWithArray:[[rosters objectAtIndex:indexPath.row] snares]];
    srvc.tenors = [[rosters objectAtIndex:indexPath.row] tenors];
    srvc.basses = [[rosters objectAtIndex:indexPath.row] basses];
    srvc.cymbals = [[rosters objectAtIndex:indexPath.row] cymbals];
    srvc.year = [NSString stringWithFormat:@"%@", [[rosters objectAtIndex:indexPath.row] the_year]];
    [self.navigationController pushViewController:srvc animated:YES];
    [srvc release];
}
/*
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
    
    [self displayTable];
    [self showRefreshButton];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:received_data error:&error];
    
    [self parseRosterData:results];
    
    NSLog(@"Succeeded! Received %d bytes of data.", [received_data length]);
    
    // release the connection, and the data object
    [connection release];
    [received_data release];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
*/

#pragma mark -
#pragma mark TexasDrumsGetRequestDelegate Methods

- (void)request:(TexasDrumsGetRequest *)request receivedData:(id)data {
    NSLog(@"Obtained rosters successfully.");
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:data error:&error];
    [self parseRosterData:results];
}

- (void)request:(TexasDrumsGetRequest *)request failedWithError:(NSError *)error {
    NSLog(@"Request error: %@", error);
}


@end
