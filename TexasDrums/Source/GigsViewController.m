//
//  GigsViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 7/14/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "GigsViewController.h"
#import "TexasDrumsRequest.h"
#import "SVProgressHUD.h"
#import "GANTracker.h"
#import "TexasDrumsGroupedTableViewCell.h"
#import "CJSONDeserializer.h"

#import "UIFont+TexasDrums.h"
#import "UIColor+TexasDrums.h"
#import "TexasDrumsGetGigs.h"
#import "Common.h"

#import "Gig.h"
#import "GigUser.h"

@interface GigsViewController ()

@end

@implementation GigsViewController

@synthesize gigsTable, gigs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        gigs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Gigs"];
    
    // Set properties.
    self.gigsTable.backgroundColor = [UIColor clearColor];
    self.gigsTable.alpha = 0.0f;
    
    // Begin fetching news from the server.
    [self connect];
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

- (void)dismissWithSuccess {
    [SVProgressHUD dismiss];
}

- (void)dismissWithError {
    [SVProgressHUD showErrorWithStatus:@"Could not get gigs."];
}

- (void)displayTable {
    [self.gigsTable reloadData];
    [UIView animateWithDuration:0.5f animations:^{
        self.gigsTable.alpha = 1.0f;
    }];
}

#pragma mark - Data Methods

- (void)connect {
    [SVProgressHUD showWithStatus:@"Loading..."];
    TexasDrumsGetGigs *get = [[TexasDrumsGetGigs alloc] initWithUsername:_Profile.username andPassword:_Profile.password];
    get.delegate = self;
    [get startRequest];
}

- (void)parseGigData:(NSDictionary *)results {
    for(NSDictionary *item in results) {
        Gig *gig = [[[Gig alloc] init] autorelease];
        
        gig.gig_name = [item objectForKey:@"name"];
        gig.gig_id = [[item objectForKey:@"gig_id"] intValue];
        gig.location = [item objectForKey:@"location"];
        gig.description = [item objectForKey:@"description"];
        gig.timestamp = [[item objectForKey:@"time"] intValue];
        gig.snares_required = [[item objectForKey:@"snares_required"] intValue];
        gig.tenors_required = [[item objectForKey:@"tenors_required"] intValue];
        gig.basses_required = [[item objectForKey:@"basses_required"] intValue];
        gig.cymbals_required = [[item objectForKey:@"cymbals_required"] intValue];
        
        // Parse timestamp.
        [gig convertTimestampToString];
        
        for(NSDictionary *users in [item objectForKey:@"users"]) {
            GigUser *user = [[[GigUser alloc] init] autorelease];
            user.firstname = [users objectForKey:@"first_name"];
            user.lastname = [users objectForKey:@"last_name"];
            user.section = [users objectForKey:@"section"];
            user.user_id = [[users objectForKey:@"user_id"] intValue];

            [gig.users addObject:user];
        }
        
        [gigs addObject:gig];
    }
    
    [self displayTable];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [gigs count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return HEADER_HEIGHT;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    // Create a custom header.
    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, HEADER_HEIGHT)] autorelease];
    UILabel *headerTitle = [[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 30)] autorelease];
    
    Gig *gig = [gigs objectAtIndex:section];
    
    headerTitle.text = gig.gig_name;
    
    headerTitle.textAlignment = UITextAlignmentLeft;
    headerTitle.textColor = [UIColor TexasDrumsOrangeColor];
    headerTitle.font = [UIFont TexasDrumsBoldFontOfSize:18];
    headerTitle.backgroundColor = [UIColor clearColor];
    headerTitle.shadowOffset = CGSizeMake(0, 1);
    
    [containerView addSubview:headerTitle];
    
	return containerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Gig *gig = [gigs objectAtIndex:indexPath.section];
    NSString *text;
    
    switch (indexPath.row) {
        case 0:
            text = [NSString stringWithFormat:@"%d", gig.timestamp_string];
            break;
        case 1:
            text = gig.location;
            break;
        case 2:
            text = gig.description;
            break;
        case 3:
            text = [gig createRequiredText];
            break;
        case 4:
            text = [gig createCurrentText];
            break;
        default:
            text = @""; // Should never get hit.
            break;
    }
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont TexasDrumsFontOfSize:15] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 20.0f) + CELL_CONTENT_MARGIN * 2;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
        
        // Override TexasDrumsGroupedTableViewCell properties. 
        cell.detailTextLabel.textColor = [UIColor TexasDrumsGrayColor];
        cell.textLabel.textColor = [UIColor TexasDrumsOrangeColor];
        
        cell.detailTextLabel.font = [UIFont TexasDrumsFontOfSize:14];
        cell.textLabel.font = [UIFont TexasDrumsFontOfSize:12];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    

    
    /*
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
    else if(indexPath.row == 4){
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
    */
    Gig *gig = [gigs objectAtIndex:indexPath.section];

    cell.detailTextLabel.numberOfLines = 0;
    
    switch(indexPath.row) {
        case 0:
            cell.textLabel.text = @"Date";
            cell.detailTextLabel.text = gig.timestamp_string;
            break;
        case 1:
            cell.textLabel.text = @"Location";
            cell.detailTextLabel.text = gig.location;
            break;
        case 2:
            cell.textLabel.text = @"Description";
            cell.detailTextLabel.text = gig.description;
            break;
        case 3:
            cell.textLabel.text = @"Required";
            cell.detailTextLabel.text = [gig createRequiredText];
            break;
        case 4:
            cell.textLabel.text = @"Need";
            cell.detailTextLabel.text = [gig createCurrentText];
            break;
        default:
            break;
    }
    
    return cell;
}

#warning - this needs to be improved; we need to custom draw these cells to improve performance.
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.contentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.gigsTable deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TexasDrumsRequestDelegate Methods

- (void)request:(TexasDrumsRequest *)request receivedData:(id)data {

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
            if([[results objectForKey:@"status"] isEqualToString:_GIGS_API_NO_GIGS_AVAILABLE]) {
                TDLog(@"No gigs found. Request returned: %@", [results objectForKey:@"status"]);
                [self dismissWithSuccess];
                return;
            }
        }
        
        TDLog(@"Gigs found. Parsing..");
        // Deserialize JSON results and parse them into News objects.
        [self parseGigData:results];
        [self dismissWithSuccess];
    }
    else {
        TDLog(@"Could not retrieve gigs.");
        [self dismissWithError];
    }
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    TDLog(@"Request error: %@", error);
    
    // Show refresh button and error message.
    [self dismissWithError];
}

@end
