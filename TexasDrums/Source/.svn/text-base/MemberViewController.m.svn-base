//
//  MemberViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 University of Texas at Austin. All rights reserved.
//

#import "MemberViewController.h"
#import "MemberLoginViewController.h"
#import "ProfileViewController.h"
#import "AddressBookViewController.h"
#import "AddMemberViewController.h"
#import "PaymentViewController.h"
#import "DownloadMusicViewController.h"
#import "GANTracker.h"

@implementation MemberViewController

#define _HEADER_HEIGHT_ (50)
#define _200OK (@"200 OK")

@synthesize membersOptions, memberTable, loginText, received_data;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Members"];
    self.loginText.alpha = 0.0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults boolForKey:@"login_valid"]){
        //accepted username. show member stuff
        membersOptions = [[NSArray alloc] initWithObjects:@"View Music", @"View Address Book", @"View Profile", nil];
       //membersOptions = [[NSArray alloc] initWithObjects:@"View/Download Music", @"View Address Book", @"View Available Gigs", @"View Profile", nil];
    }
}

- (void)showMemberLoginScreen {
    MemberLoginViewController *memberLoginView = [[MemberLoginViewController alloc] init];
    [memberLoginView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self.navigationController presentModalViewController:memberLoginView animated:YES];
    [memberLoginView release];
}

- (void)destroyProfile {
    _Profile = nil;
    [_Profile release];
}

- (IBAction)logoutButtonPressed:(id)sender {
    [self startConnection];
    /*
    NSString *response = [self getLogoutResponse];
    if(DEBUG_MODE) NSLog(@"Member Logout response from server: %@", response);
    if([response isEqualToString:_200OK]){
        [self logout];
    }
    else{

    }
     */
}

- (void)startConnection {
    // Login first
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&username=%@&password=%@&device=mobile", TEXAS_DRUMS_API_LOGOUT, TEXAS_DRUMS_API_KEY, _Profile.username, _Profile.password];
    NSLog(@"%@", API_Call);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLConnection *urlconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if(urlconnection) {
        received_data = [[NSMutableData data] retain];
    }
}

- (void)checkLoginResponse:(NSData *)response {
    NSString *get = [[[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding] autorelease]; 
    if([get isEqualToString:_200OK]){
        [self logout];
    }
    else{
        
    }
}

- (void)logout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"login_username"];
    [defaults setObject:@"" forKey:@"login_password"];
    [defaults setBool:NO forKey:@"login_valid"];
    [defaults setBool:NO forKey:@"member"];
    //this should be a class method; change later.
    [self destroyProfile];
    MemberLoginViewController *memberLoginView = [[MemberLoginViewController alloc] init];
    [memberLoginView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self.navigationController presentModalViewController:memberLoginView animated:YES];
    [memberLoginView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[GANTracker sharedTracker] trackPageview:@"Members (MemberView)" withError:nil];
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults boolForKey:@"login_valid"]){
        //show modal view
        self.loginText.alpha = 1.0;
        self.memberTable.alpha = 0.0;
        UIBarButtonItem *login = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleDone target:self action:@selector(showMemberLoginScreen)];
        self.navigationItem.rightBarButtonItem = login;
        [login release];
    }
    else{
        UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(logoutButtonPressed:)];
        self.navigationItem.rightBarButtonItem = logout;
        [logout release];
        self.memberTable.alpha = 1.0;
        self.loginText.alpha = 0.0;
        //accepted username. show member stuff
        if(membersOptions == nil){
            membersOptions = [[NSArray alloc] initWithObjects:@"View Music", @"View Address Book", @"View Profile", nil];
        }
        [self.memberTable reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.memberTable.backgroundColor = [UIColor clearColor];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_Profile.admin){
        return 2;
    }
    else{
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return @"Member Options";
    }
    else if(section == 1){
        return @"Administrative Options";
    }
    else return @"";
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return _HEADER_HEIGHT_;
}

//This method overrides the titleForHeaderInSection method.
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    
    //create a new view of size _HEADER_HEIGHT_, and place a label inside.
    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, _HEADER_HEIGHT_)] autorelease];
    UILabel *headerTitle = [[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 30)] autorelease];
    headerTitle.textAlignment = UITextAlignmentLeft;
    headerTitle.textColor = [UIColor orangeColor];
    //headerTitle.shadowColor = [UIColor blackColor];
    headerTitle.shadowOffset = CGSizeMake(0, 1);
    headerTitle.font = [UIFont fontWithName:@"Georgia-Bold" size:18];
    headerTitle.backgroundColor = [UIColor clearColor];
    [containerView addSubview:headerTitle];
    
    if(section == 0){
        headerTitle.text = @"Member Options";
    }
    else if(section == 1){
        headerTitle.text = @"Administrative Options";
    }
    
	return containerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    //configure cell font, color, and background
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:16];
    cell.textLabel.textAlignment = UITextAlignmentLeft;    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.clipsToBounds = YES;
    
    //configure cell text and background
    if(indexPath.section == 0){
        cell.textLabel.text = [membersOptions objectAtIndex:indexPath.row];
        
        //configure cell background images
        if(indexPath.row == 0){
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_table_cell.png"]] autorelease];
            ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"top_table_cell.png"];
        }
        if(indexPath.row != 0 && indexPath.row != [membersOptions count] - 1){
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell.png"]] autorelease];
            ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"table_cell.png"];
        }
        if(indexPath.row == [membersOptions count] - 1){
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_table_cell.png"]] autorelease];
            ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
        }
        
        //configure cell selection background images here
        if(indexPath.row == 0){
            cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_table_cell.png"]] autorelease];
            ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"top_table_cell.png"];
        }
        if(indexPath.row != 0 && indexPath.row != [membersOptions count] - 1){
            cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell.png"]] autorelease];
            ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"table_cell.png"];
        }
        if(indexPath.row == [membersOptions count] - 1){
            cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_table_cell.png"]] autorelease];
            ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
        }
    }
    else if(_Profile.admin){
        if(indexPath.section == 1){
            switch(indexPath.row){
                case 0:
                    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_table_cell.png"]] autorelease];
                    ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"top_table_cell.png"];
                    cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_table_cell.png"]] autorelease];
                    ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"top_table_cell.png"];

                    cell.textLabel.text = @"Modify Dues";
                    break;
                case 1:
                    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_table_cell.png"]] autorelease];
                    ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
                    cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_table_cell.png"]] autorelease];
                    ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
                    cell.textLabel.text = @"Add A Member";
                    break;
                default:
                    break;
            }
        }
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.memberTable deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            DownloadMusicViewController *downloadMusic = [[DownloadMusicViewController alloc] initWithNibName:@"DownloadMusicView" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:downloadMusic animated:YES];
            [downloadMusic release];
        }
        else if(indexPath.row == 1){
            AddressBookViewController *addressBook = [[AddressBookViewController alloc] initWithNibName:@"AddressBookView" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:addressBook animated:YES];
            [addressBook release];
        }
        else 	if(indexPath.row == 2){
            ProfileViewController *profile = [[ProfileViewController alloc] initWithNibName:@"ProfileView" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:profile animated:YES];
            [profile release];
        }
    }
    else{
        if(indexPath.row == 0){
            PaymentViewController *payment = [[PaymentViewController alloc] initWithNibName:@"PaymentView" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:payment animated:YES];
            [payment release];
        }
        if(indexPath.row == 1){
            AddMemberViewController *addMember = [[AddMemberViewController alloc] initWithNibName:@"AddMemberView" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:addMember animated:YES];
            [addMember release];
        }
    }
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    [received_data setLength:0];
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
    
    //[indicator stopAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self checkLoginResponse:received_data];
    
    NSLog(@"Succeeded! Received %d bytes of data", [received_data length]);
    
    // release the connection, and the data object
    [connection release];
    [received_data release];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
