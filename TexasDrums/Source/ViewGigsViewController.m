//
//  ViewGigsViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 7/14/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "ViewGigsViewController.h"
#import "TexasDrumsRequest.h"
#import "SVProgressHUD.h"
#import "GANTracker.h"
#import "TexasDrumsGroupedTableViewCell.h"

#import "UIFont+TexasDrums.h"
#import "UIColor+TexasDrums.h"
#import "TexasDrumsGetGigs.h"
#import "Common.h"

#import "Gig.h"
#import "GigUser.h"

@interface ViewGigsViewController ()

@end

@implementation ViewGigsViewController

@synthesize gigsTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (void)logoutButtonPressed {
    [self connect];
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
        
        gig.gig_id = [item objectForKey:@"gig_id"];
        gig.gig_name = [item objectForKey:@"name"];
        
        for(NSDictionary *users in [item objectForKey:@"users"]) {
            GigUser *user = [[[GigUser alloc] init] autorelease];
            user.firstname = [users objectForKey:@"first_name"];
            user.lastname = [users objectForKey:@"last_name"];
            user.user_id = [[users objectForKey:@"user_id"] intValue];

            [gig.users addObject:user];
        }
        
        [gigs addObject:gig];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [gigs count];
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
    
    if(section == 0){
        headerTitle.text = @"Member Options";
    }
    else if(section == 1){
        headerTitle.text = @"Administrative Options";
    }
    
    headerTitle.textAlignment = UITextAlignmentLeft;
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
    cell.textLabel.font = [UIFont TexasDrumsBoldFontOfSize:16];
    
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
    else if(indexPath.row == [options count]-1){
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
    
    cell.textLabel.text = [options objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.gigsTable deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TexasDrumsRequestDelegate Methods

- (void)request:(TexasDrumsRequest *)request receivedData:(id)data {
    NSString *responseString = [NSString stringWithUTF8String:[data bytes]];
    
    if([responseString isEqualToString:_200OK]) {
        TDLog(@"Logged out successfully.");

        [self dismissWithSuccess];
    }
    else {
        TDLog(@"Could not log out.");
        [self dismissWithError];
    }
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    TDLog(@"Request error: %@", error);
    
    // Show refresh button and error message.
    [self dismissWithError];
}

@end
