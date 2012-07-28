//
//  MemberViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "MemberViewController.h"
#import "MemberLoginViewController.h"
#import "ProfileViewController.h"
#import "AddressBookViewController.h"
#import "AddMemberViewController.h"
#import "PaymentViewController.h"
#import "GigsViewController.h"
#import "DownloadMusicViewController.h"
#import "TexasDrumsGroupedTableViewCell.h"
#import "TexasDrumsGetMemberLogout.h"
#import "TexasDrumsAppDelegate.h"
#import "CJSONDeserializer.h"

@implementation MemberViewController

@synthesize membersOptions, memberTable, loginPrompt, adminOptions, delegate;

#pragma mark - Memory Management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        delegate = (TexasDrumsAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)dealloc
{
    [memberTable release];
    [membersOptions release];
    [super dealloc];
}

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
    [[GANTracker sharedTracker] trackPageview:@"Members (MemberView)" withError:nil];
    
    self.loginPrompt.alpha = 1.0f;
    self.memberTable.alpha = 1.0f;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // If user is not logged in, show login prompt.
    if(![defaults boolForKey:@"login_valid"]){
        self.loginPrompt.hidden = NO;
        self.memberTable.hidden = YES;
        
        [self setButton:kLogin];
    }
    else{
        self.loginPrompt.hidden = YES;
        self.memberTable.hidden = NO;
        
        [self setButton:kLogout];
        
#warning - move this in init.
        //accepted username. show member stuff
        if(membersOptions == nil){
            membersOptions = [[NSArray alloc] initWithObjects:@"View Music", @"View Address Book", @"View Profile", @"View Gigs", nil];
            adminOptions = [[NSArray alloc] initWithObjects:@"Modify Dues", @"Add A Member", nil];
        }
        
        [self.memberTable reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Members"];
    
    // Set properties.
    self.memberTable.backgroundColor = [UIColor clearColor];
    self.loginPrompt.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
        titleView = [UILabel TexasDrumsNavigationBar];
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}

- (void)setButton:(ButtonType)buttonType {
    
    UIBarButtonItem *button;
    
    if(buttonType == kLogin) {
        button = [[[UIBarButtonItem alloc] initWithTitle:@"Login" 
                                                   style:UIBarButtonItemStyleDone 
                                                  target:self 
                                                  action:@selector(showMemberLoginScreen)] autorelease];
    }
    else if(buttonType == kLogout) {
        button = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" 
                                                   style:UIBarButtonItemStyleDone 
                                                  target:self 
                                                  action:@selector(logoutButtonPressed)] autorelease];
    }
    else return;
    
    self.navigationItem.rightBarButtonItem = button;
    
}

- (void)dismissWithSuccess {
    [SVProgressHUD dismiss];
}

- (void)dismissWithError {
    [SVProgressHUD showErrorWithStatus:@"Could not log out."];
}

- (void)showMemberLoginScreen {
    MemberLoginViewController *MLVC = [[[MemberLoginViewController alloc] init] autorelease];
    [MLVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self.navigationController presentModalViewController:MLVC animated:YES];
}   

- (void)logoutButtonPressed {
    [self connect];
}

#pragma mark - Data Methods

- (void)connect {
    [SVProgressHUD showWithStatus:@"Logging out..."];
    TexasDrumsGetMemberLogout *get = [[TexasDrumsGetMemberLogout alloc] initWithUsername:_Profile.username andPassword:_Profile.password];
    get.delegate = self;
    [get startRequest];
}

- (void)logout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:NO forKey:@"login_valid"];
    [defaults setBool:NO forKey:@"member"];
    
    [delegate destroyProfile];
    
    // Smoothly transition back into the login prompt.
    self.loginPrompt.alpha = 0.0f;
    self.loginPrompt.hidden = NO;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.loginPrompt.alpha = 1.0f;
        self.memberTable.alpha = 0.0f;
    }];
    
    [self setButton:kLogin];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_Profile.admin){
        return 2;
    }

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_Profile.admin){
        if(section == 0){
            return [membersOptions count];
        }
        else return 2;
    }
    else{
        return [membersOptions count];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return HEADER_HEIGHT;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    NSString *sectionTitle;
    
    if(section == 0){
        sectionTitle = @"Member Options";
    }
    else if(section == 1){
        sectionTitle = @"Administrative Options";
    }
    
    UIView *header = [UIView TexasDrumsGroupedTableHeaderViewWithTitle:sectionTitle andAlignment:UITextAlignmentLeft];
    
	return header;
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
    
    NSArray *options;
    
    switch(indexPath.section) {
        case 0:
            options = membersOptions;
            break;
        case 1:
            options = adminOptions;
            break;
        default:
            options = nil;
            break;
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
    [self.memberTable deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            DownloadMusicViewController *DMVC = [[[DownloadMusicViewController alloc] initWithNibName:@"DownloadMusicView" bundle:[NSBundle mainBundle]] autorelease];
            [self.navigationController pushViewController:DMVC animated:YES];
        }
        if(indexPath.row == 1){
            AddressBookViewController *ABVC = [[[AddressBookViewController alloc] initWithNibName:@"AddressBookView" bundle:[NSBundle mainBundle]] autorelease];
            [self.navigationController pushViewController:ABVC animated:YES];
        }
        if(indexPath.row == 2){
            ProfileViewController *PVC = [[[ProfileViewController alloc] initWithNibName:@"ProfileView" bundle:[NSBundle mainBundle]] autorelease];
            [self.navigationController pushViewController:PVC animated:YES];
        }
        if(indexPath.row == 3){
            GigsViewController *GVC = [[[GigsViewController alloc] initWithNibName:@"GigsViewController" bundle:[NSBundle mainBundle]] autorelease];
            [self.navigationController pushViewController:GVC animated:YES];
        }
    }
    else{
        if(indexPath.row == 0){
            PaymentViewController *PVC = [[[PaymentViewController alloc] initWithNibName:@"PaymentView" bundle:[NSBundle mainBundle]] autorelease];
            [self.navigationController pushViewController:PVC animated:YES];
        }
        if(indexPath.row == 1){
            AddMemberViewController *AMVC = [[[AddMemberViewController alloc] initWithNibName:@"AddMemberView" bundle:[NSBundle mainBundle]] autorelease];
            [self.navigationController pushViewController:AMVC animated:YES];
        }
    }
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
            if([[results objectForKey:@"status"] isEqualToString:_200OK]) {
                TDLog(@"Logged out successfully. Request returned: %@", [results objectForKey:@"status"]);
                [self logout];
                [self dismissWithSuccess];
                return;
            }
        }
        else {
            TDLog(@"Could not log out.");
            [self dismissWithError];
        }
    }
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    TDLog(@"Request error: %@", error);
    
    // Show refresh button and error message.
    [self dismissWithError];
}


@end
