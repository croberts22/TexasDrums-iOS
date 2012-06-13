//
//  AddressBookViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 8/14/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "AddressBookViewController.h"
#import "CJSONDeserializer.h"
#import "AddressBookMemberViewController.h"
#import "GANTracker.h"

@implementation AddressBookViewController

#define _HEADER_HEIGHT_ (25)

@synthesize addressBookTable, sorter, addressBook, indicator, full_name, sections, membership, received_data, status;

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

- (void)dealloc {
    [addressBookTable release];
    [sorter release];
    [sections release];
    [super dealloc];
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
    [[GANTracker sharedTracker] trackPageview:@"Address Book (AddressBookView)" withError:nil];
    NSIndexPath *indexPath = [self.addressBookTable indexPathForSelectedRow];
    if(indexPath) {
        [self.addressBookTable deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Address Book"];
    
    self.sorter.alpha = 0.0f;
    self.sorter.enabled = NO;
    self.addressBookTable.alpha = 0.0f;
    self.indicator.alpha = 1.0f;
    self.status.alpha = 1.0f;
    self.status.text = @"Loading...";
    self.addressBookTable.separatorColor = [UIColor darkGrayColor];
    
    if(addressBook == nil){
        addressBook = [[NSMutableArray alloc] init];
    }
    if(full_name == nil){
        full_name = [[NSMutableDictionary alloc] init];
    }
    if(sections == nil){
        sections = [[NSMutableDictionary alloc] init];
    }
    if(membership == nil){
        membership = [[NSMutableDictionary alloc] init];
    }
    
    [indicator startAnimating];
    
    [self fetchAddressBook];
}

- (void)displayTable {
    float delay = 1.0f;
    self.sorter.enabled = YES;
    [self.addressBookTable reloadData];
    [UIView beginAnimations:@"displayAddressBook" context:NULL];
    [UIView setAnimationDelay:delay];
    self.addressBookTable.alpha = 1.0f;
    self.sorter.alpha = 1.0f;
    self.indicator.alpha = 0.0f;
    self.status.alpha = 0.0f;
    [UIView commitAnimations];
    [self.indicator performSelector:@selector(stopAnimating) withObject:nil afterDelay:delay+.25];
}

- (void)fetchAddressBook {
    [self startConnection];
}

- (void)startConnection {
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&username=%@&password=%@", TEXAS_DRUMS_API_ACCOUNTS, TEXAS_DRUMS_API_KEY, _Profile.username, _Profile.password];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLConnection *urlconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if(urlconnection) {
        received_data = [[NSMutableData data] retain];
    }
}

- (void)parseAddressBookData:(NSDictionary *)results {    
    for(NSDictionary *item in results){
        Profile *profile = [self createNewProfile:item];
        if(profile.valid){
            [addressBook addObject:profile];
        }
    }
    [self sortMembersByName];
    //Any changes to UI must be done on main thread.
    [self performSelectorOnMainThread:@selector(displayTable) withObject:nil waitUntilDone:YES];
    
}

- (Profile *)createNewProfile:(NSDictionary *)item {
    Profile *member_profile = [[[Profile alloc] init] autorelease];
    
    member_profile.firstname = [item objectForKey:@"firstname"];
    member_profile.lastname = [item objectForKey:@"lastname"];
    member_profile.username = [item objectForKey:@"username"];
    member_profile.section = [item objectForKey:@"section"];
    member_profile.years = [item objectForKey:@"years"];
    member_profile.status = [item objectForKey:@"status"];
    
    member_profile.birthday = [item objectForKey:@"birthday"];
    member_profile.email = [item objectForKey:@"email"];
    member_profile.phonenumber = [item objectForKey:@"phonenumber"];
    member_profile.sl = [[item objectForKey:@"sl"] intValue];
    member_profile.valid = [[item objectForKey:@"valid"] boolValue];
    
    member_profile.alphabet_first = [NSString stringWithFormat:@"%c", [member_profile.firstname characterAtIndex:0]];
    member_profile.alphabet_last = [NSString stringWithFormat:@"%c", [member_profile.lastname characterAtIndex:0]];
    
    return member_profile;
}

- (void)sortMembersByName {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"firstname" ascending:YES];
    [addressBook sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [descriptor release];
    
    //now, grab all alpha characters
    [self grabCharacters];
}

- (void)grabCharacters {
    BOOL found;
    
    for (Profile *this_profile in addressBook){
        NSString *c = this_profile.alphabet_first;
        found = FALSE;
        for (NSString *str in [self.full_name allKeys]){
            if ([str isEqualToString:c]){
                found = TRUE;
            }
        }
        if (!found){
            [self.full_name setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }

    for (Profile *this_profile in addressBook){
        NSString *c = this_profile.section;
        found = FALSE;
        for (NSString *str in [self.sections allKeys]){
            if ([str isEqualToString:c]){
                found = TRUE;
            }
        }
        if (!found){
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
    
    for (Profile *this_profile in addressBook){
        NSString *c = this_profile.status;
        found = FALSE;
        for (NSString *str in [self.membership allKeys]){
            if ([str isEqualToString:c]){
                found = TRUE;
            }
        }
        if (!found){
            [self.membership setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
    
    
    for (Profile *this_profile in addressBook){
        [[full_name objectForKey:this_profile.alphabet_first] addObject:this_profile];
        [[sections objectForKey:this_profile.section] addObject:this_profile];
        [[membership objectForKey:this_profile.status] addObject:this_profile];
    }
    
    for (NSString *key in [self.sections allKeys]){
        //Name Table
        [[self.full_name objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"firstname" ascending:YES]]];
        
        //Section Table
        [[self.sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"section" ascending:YES]]];
        
        //Status/Membership Table
        [[self.membership objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"status" ascending:YES]]];
    }
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

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(sorter.selectedSegmentIndex == 0){
        return [[full_name allKeys] count];
    }
    else if(sorter.selectedSegmentIndex == 1){
        return [[sections allKeys] count];
    }
    else{
        return [[membership allKeys] count];
    }
    return 0;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(sorter.selectedSegmentIndex == 0){
        return [[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    }
    else if(sorter.selectedSegmentIndex == 1){
        switch(section){
            case 0:
                return @"Snares";
                break;
            case 1:
                return @"Tenors";
                break;
            case 2:
                return @"Basses";
                break;
            case 3:
                return @"Cymbals";
                break;
            case 4:
                return @"Instructors";
                break;
            default:
                break;
        }
    }
    else if(sorter.selectedSegmentIndex == 2){
        if(section == 0){
            return @"Current Members";
        }
        else return @"Alumni Members";
    }
    
    return @"";
}
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(sorter.selectedSegmentIndex == 0){ 
        return [[full_name valueForKey:[[[full_name allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
    }
    else if(sorter.selectedSegmentIndex == 1){
        return [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
    }
    else if(sorter.selectedSegmentIndex == 2){
        return [[membership valueForKey:[[[membership allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
    }
    else return 0;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if(sorter.selectedSegmentIndex == 0){
        return [[full_name allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Profile *profile;

    if(sorter.selectedSegmentIndex == 0){
        profile = [[full_name valueForKey:[[[full_name allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    else if(sorter.selectedSegmentIndex == 1){
        profile = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    else{
        profile = [[membership valueForKey:[[[membership allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }

    // Configure the cell...
    cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uitableviewselection-orange-44.png"]] autorelease];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", profile.firstname, profile.lastname];
    cell.textLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:16];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    //create a new view of size _HEADER_HEIGHT_, and place a label inside.
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, _HEADER_HEIGHT_)];
    
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, _HEADER_HEIGHT_)];
    if(sorter.selectedSegmentIndex == 0){
        headerTitle.text = [[[full_name allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    }
    else if(sorter.selectedSegmentIndex == 1){
        headerTitle.text = [[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];    
    }
    else if(sorter.selectedSegmentIndex == 2){
       headerTitle.text = [[[membership allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    }
    
    headerTitle.textAlignment = UITextAlignmentLeft;
    headerTitle.textColor = [UIColor orangeColor];
    headerTitle.shadowOffset = CGSizeMake(0, 1);
    headerTitle.font = [UIFont fontWithName:@"Georgia-Bold" size:18];
    headerTitle.backgroundColor = [UIColor clearColor];
    
    UILabel *blackBackground = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)] autorelease];
                            
    blackBackground.backgroundColor = [UIColor blackColor];
    
    [containerView addSubview:blackBackground];
    [containerView addSubview:headerTitle];
    
	return containerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressBookMemberViewController *ABMVC = [[AddressBookMemberViewController alloc] init];
    ABMVC.profile = [[full_name valueForKey:[[[full_name allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:ABMVC animated:YES];
    [ABMVC release];
}

- (IBAction)sorterChanged:(id)sender{
    [self.addressBookTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.addressBookTable reloadData];
}

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
    
    [indicator stopAnimating];
    self.status.text = @"Nothing was found. Please try again later.";
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:received_data error:&error];
    
    [self parseAddressBookData:results];
    
    NSLog(@"Succeeded! Received %d bytes of data.", [received_data length]);
    
    // release the connection, and the data object
    [connection release];
    [received_data release];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
