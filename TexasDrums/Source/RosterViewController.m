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
#import "SingleRosterViewController.h"
#import "TexasDrumsGroupedTableViewCell.h"
#import "TexasDrumsGetRosters.h"

// Utilities
#import "CJSONDeserializer.h"

@interface RosterViewController() {
    TexasDrumsGetRosters *getRosters;
}

@property (nonatomic, retain) TexasDrumsGetRosters *getRosters;

- (void)refreshPressed;
- (void)hideRefreshButton;
- (void)displayTable;
- (void)parseRosterData:(NSDictionary *)results;

@end

@implementation RosterViewController

@synthesize getRosters;
@synthesize rosters, rosterTable, refresh;

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    self.getRosters.delegate = nil;
    [getRosters release], getRosters = nil;
    [rosters release], rosters = nil;
    [rosterTable release], rosterTable = nil;
    [refresh release], refresh = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = [self.rosterTable indexPathForSelectedRow];
    if(indexPath) {
        [self.rosterTable deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewDidLoad {
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
    self.refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshPressed)];
    
    self.navigationItem.rightBarButtonItem = refresh;
    
    // Begin fetching roster from the server.
    if([rosters count] == 0){
        [self connect];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI Methods

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
    [self.rosterTable reloadData];
    [UIView animateWithDuration:0.5f animations:^{
        if([rosters count] > 0){
            self.rosterTable.alpha = 1.0f;
        }
        else {
            self.rosterTable.alpha = 0.0f;
        }
    }];
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
            [roster sortSections];
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
        RosterMember *roster_member = [RosterMember createNewRosterMember:member];
        [roster addMember:roster_member];
    }
    
    // Display the table after all data is acquired.
    [self displayTable];
    
    if(DEBUG_MODE) TDLog(@"Roster table configured. Reloading...");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [rosters count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [UIView TexasDrumsGroupedTableHeaderViewWithTitle:@"Select a year:" andAlignment:UITextAlignmentCenter];

	return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    TexasDrumsGroupedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TexasDrumsGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    
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

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SingleRosterViewController *SRVC = [[[SingleRosterViewController alloc] initWithNibName:@"SingleRosterView" bundle:[NSBundle mainBundle]] autorelease];
    
    SRVC.roster = [rosters objectAtIndex:indexPath.row];
    SRVC.year = [[rosters objectAtIndex:indexPath.row] the_year];
    
    [self.navigationController pushViewController:SRVC animated:YES];
}

#pragma mark - TexasDrumsRequestDelegate Methods

- (void)request:(TexasDrumsRequest *)request receivedData:(id)data {
    TDLog(@"Obtained rosters successfully.");
    
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
                TDLog(@"No rosters found. Request returned: %@", [results objectForKey:@"status"]);
                [self dismissWithSuccess];
                return;
            }
        }
        
        TDLog(@"New rosters found. Parsing..");
        // Deserialize JSON results and parse them into Roster objects.

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
