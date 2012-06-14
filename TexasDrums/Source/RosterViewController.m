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
#import "SVProgressHUD.h"

@implementation RosterViewController

#define _HEADER_HEIGHT_ (50)

@synthesize rosters, rosterTable, refresh;

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

- (void)displayTable {
    float duration = 0.5f;
    [self.rosterTable reloadData];
    
    [UIView beginAnimations:@"displayRosterTable" context:NULL];
    [UIView setAnimationDuration:duration];
    if([rosters count] > 0){
        self.rosterTable.alpha = 1.0f;
    }
    else {
        self.rosterTable.alpha = 0.0f;
    }
    [UIView commitAnimations];
    
    [SVProgressHUD dismiss];
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
    self.rosterTable.backgroundColor = [UIColor clearColor];
    self.rosterTable.separatorColor = [UIColor clearColor];
    
    if(rosters == nil){
        rosters = [[NSMutableArray alloc] init];
    }
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
    if([rosters count] == 0){
        [self connect];
    }
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
    [self hideRefreshButton];
    [SVProgressHUD showWithStatus:@"Loading..."];
    TexasDrumsGetRosters *get = [[TexasDrumsGetRosters alloc] init];
    get.delegate = self;
    [get startRequest]; 
}

- (void)refreshPressed {
    [self connect];
}


/*

- (void)fetchRosters {
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
 */

- (void)parseRosterData:(NSDictionary *)results {
    NSString *current_year = @"";
    for(NSDictionary *member in results) {
        
        Roster *roster;

        // If the year is not set, set it.
        if([current_year isEqualToString:@""]){
            current_year = [member objectForKey:@"year"];    
            roster = [[Roster alloc] initWithYear:current_year];
        }
        
        // Grab the current year.  If it's different, we know it's a new year/roster.
        NSString *this_year = [member objectForKey:@"year"];        
        
        if(![current_year isEqualToString:this_year]){
            
            // Set the new current year.
            current_year = [member objectForKey:@"year"];
            
            // Sort and add the roster to the full roster list.
            [self sortSections:roster];
            [rosters addObject:roster];
            [roster release];
            
            // If last object in the JSON response is NULL, break the loop.
            if([member objectForKey:@"year"] == [NSNull null]){
                break;
            }
            
            // After adding the roster to the rosters array, create a new one.
            roster = [[Roster alloc] initWithYear:current_year];
        }
        
        // Create a roster member and add it to the respective group.
        RosterMember *roster_member = [self createNewRosterMember:member];
        
        if([roster_member.instrument isEqualToString:@"Snare"]){
            [roster.snares addObject:roster_member];
        }
        else if([roster_member.instrument isEqualToString:@"Tenors"]){
            [roster.tenors addObject:roster_member];
        }
        else if([roster_member.instrument isEqualToString:@"Bass"]){
            [roster.basses addObject:roster_member];
        }
        else if([roster_member.instrument isEqualToString:@"Cymbals"]){
            [roster.cymbals addObject:roster_member];
        }
    }
    
    // Display the table after all data is acquired.
    [self displayTable];
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
    srvc.snares = [[rosters objectAtIndex:indexPath.row] snares];
    srvc.tenors = [[rosters objectAtIndex:indexPath.row] tenors];
    srvc.basses = [[rosters objectAtIndex:indexPath.row] basses];
    srvc.cymbals = [[rosters objectAtIndex:indexPath.row] cymbals];
    srvc.year = [[rosters objectAtIndex:indexPath.row] the_year];
    [self.navigationController pushViewController:srvc animated:YES];
    [srvc release];
}

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
    [self showRefreshButton];
    [SVProgressHUD showErrorWithStatus:@"Could not fetch data."];
}


@end
