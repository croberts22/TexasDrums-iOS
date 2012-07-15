//
//  RosterViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "RosterViewController.h"
#import "Roster.h"
#import "RosterMember.h"
#import "Common.h"
#import "SingleRosterViewController.h"
#import "TexasDrumsGroupedTableViewCell.h"
#import "TexasDrumsGetRosters.h"

// Utilities
#import "CJSONDeserializer.h"
#import "RegexKitLite.h"
#import "GANTracker.h"
#import "SVProgressHUD.h"

// Categories
#import "UIFont+TexasDrums.h"
#import "UIColor+TexasDrums.h"


@implementation RosterViewController

@synthesize rosters, rosterTable, refresh;

#pragma mark - Memory Management

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
    [[GANTracker sharedTracker] trackPageview:@"Roster (RosterView)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Roster"];
    
    // Set properties.
    self.rosterTable.alpha = 0.0f;
    self.rosterTable.backgroundColor = [UIColor clearColor];
    self.rosterTable.separatorColor = [UIColor clearColor];

    // Allocate things as necessary.
    if(rosters == nil){
        rosters = [[NSMutableArray alloc] init];
    }
    
    // Create refresh button.
    self.refresh = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshPressed)] autorelease];
    
    self.navigationItem.rightBarButtonItem = refresh;
    
    // Begin fetching roster from the server.
    //[self connect];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([rosters count] == 0){
        [self connect];
    }
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
    // Fetch roster from the server.
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
    self.navigationItem.rightBarButtonItem = refresh;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [SVProgressHUD showErrorWithStatus:@"Could not fetch data."];
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
}

#pragma mark - Data Methods

- (void)connect {
    [self hideRefreshButton];
    [SVProgressHUD showWithStatus:@"Loading..."];
    TexasDrumsGetRosters *get = [[TexasDrumsGetRosters alloc] init];
    get.delegate = self;
    [get startRequest]; 
}

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
    if(DEBUG_MODE) TDLog(@"Roster table configured. Reloading...");
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


#warning - move to category?
- (NSString *)convertHTML:(NSString *)quote {
    NSString *searchString = quote;
    NSString *regexString = @"<br>|<br />";
    NSString *replaceWithString = @"\r\n";
    NSString *replacedString = NULL;
    
    replacedString = [searchString stringByReplacingOccurrencesOfRegex:regexString withString:replaceWithString];
    
    return replacedString;
}

- (NSString *)parsePhoneNumber:(NSString *)number {
    NSString *areacode;
    NSString *first;
    NSString *last;
    
    // A number is only valid if it is 10 or 7 digits long.
    // Anything else returns 'n/a'.
    
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
    else return @"n/a";
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    // Create a custom header.
    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, HEADER_HEIGHT)] autorelease];
    UILabel *headerTitle = [[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 30)] autorelease];

    headerTitle.text = @"";
    if([rosters count] > 0){
        headerTitle.text = @"Select a year:";
    }
    
    // Set header title properties.
    headerTitle.textAlignment = UITextAlignmentCenter;
    headerTitle.textColor = [UIColor TexasDrumsOrangeColor];
    headerTitle.font = [UIFont TexasDrumsBoldFontOfSize:18];
    headerTitle.backgroundColor = [UIColor clearColor];
    headerTitle.shadowOffset = CGSizeMake(0, 1);
    
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
    
    // Override TexasDrumsGroupedTableViewCell properties.
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    
    UIImage *background;
    UIImage *selected_background;
    
    // Since a cell's background views are not compatible with UIImageView,
    // set them both as UIImageView.
    cell.backgroundView = [[[UIImageView alloc] init] autorelease];
    cell.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];
    
    // Cell Background images.
    // TODO: Change the selected background image to something else; 
    // preferably something with an orange tint.
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[rosters objectAtIndex:indexPath.row] the_year]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // *** Consider moving this out and doing an animation in viewWillAppear when popping.
    [self.rosterTable deselectRowAtIndexPath:indexPath animated:YES];
    
    SingleRosterViewController *SRVC = [[SingleRosterViewController alloc] initWithNibName:@"SingleRosterView" bundle:[NSBundle mainBundle]];
    
    SRVC.roster = [rosters objectAtIndex:indexPath.row];
    SRVC.year = [[rosters objectAtIndex:indexPath.row] the_year];
    
    [self.navigationController pushViewController:SRVC animated:YES];
    [SRVC release];
}

#pragma mark - TexasDrumsRequestDelegate Methods

- (void)request:(TexasDrumsRequest *)request receivedData:(id)data {
    TDLog(@"Obtained rosters successfully.");
    
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:data error:&error];
    
    if([results count] > 0){
        [self parseRosterData:results];
    }
    
    [self dismissWithSuccess];
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    TDLog(@"Request error: %@", error);
    
    // Show refresh button and error message.
    [self dismissWithError];
}

@end
