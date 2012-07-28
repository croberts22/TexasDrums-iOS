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
#import "TexasDrumsGetAddressBook.h"

@implementation AddressBookViewController

@synthesize addressBookTable, sorter, addressBook, full_name, sections, membership;

#pragma mark - Memory Management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
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

- (void)viewWillAppear:(BOOL)animated {
    // Google Analytics
    [[GANTracker sharedTracker] trackPageview:@"Address Book (AddressBookView)" withError:nil];
    
    NSIndexPath *indexPath = [self.addressBookTable indexPathForSelectedRow];
    if(indexPath) {
        [self.addressBookTable deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Address Book"];
    
    // Allocate things as necessary.
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
    
    // Set properties.
    self.sorter.alpha = 0.0f;
    self.sorter.enabled = NO;
    self.addressBookTable.alpha = 0.0f;
    self.addressBookTable.separatorColor = [UIColor darkGrayColor];
    
    [self connect];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI Methods

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [UILabel TexasDrumsNavigationBar];
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}

- (void)refreshPressed {
    // Fetch music from the server.
    [self connect];
}

- (void)hideRefreshButton {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
}

- (void)dismissWithSuccess {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [SVProgressHUD dismiss];
}

- (void)dismissWithError {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [SVProgressHUD showErrorWithStatus:@"Could not fetch data."];
}

- (void)displayTable {
    self.sorter.enabled = YES;
    [self.addressBookTable reloadData];
    [UIView animateWithDuration:0.5f animations:^{
        self.addressBookTable.alpha = 1.0f;
        self.sorter.alpha = 1.0f;
    }];
}

- (IBAction)sorterChanged:(id)sender {
    [self.addressBookTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.addressBookTable reloadData];
}

#pragma mark - Data Methods

- (void)connect {
    [self hideRefreshButton];
    [SVProgressHUD showWithStatus:@"Loading..."];
    TexasDrumsGetAddressBook *get = [[TexasDrumsGetAddressBook alloc] initWithUsername:_Profile.username andPassword:_Profile.password];
    get.delegate = self;
    [get startRequest];
}

- (void)parseAddressBookData:(NSDictionary *)results {    
    for(NSDictionary *item in results){
        Profile *profile = [self createNewProfile:item];
        if(profile.valid){
            [addressBook addObject:profile];
        }
    }
    
    [self sortMembersByName];
    
    [self displayTable];
    
}

#warning - move this as a class method?
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

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if(sorter.selectedSegmentIndex == 0){
        return [[full_name allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    return nil;
}

#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(sorter.selectedSegmentIndex == 0){
        return [[full_name allKeys] count];
    }
    else if(sorter.selectedSegmentIndex == 1){
        return [[sections allKeys] count];
    }
    else {
        return [[membership allKeys] count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DEFAULT_ROW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle;
    
    if(sorter.selectedSegmentIndex == 0){
        sectionTitle = [[[full_name allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    }
    else if(sorter.selectedSegmentIndex == 1){
        sectionTitle = [[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    }
    else if(sorter.selectedSegmentIndex == 2){
        sectionTitle = [[[membership allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    }
    
    UIView *header = [UIView TexasDrumsAddressBookTableHeaderViewWithTitle:sectionTitle];
    
	return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uitableviewselection-orange-44.png"]] autorelease];
        
        cell.textLabel.font = [UIFont TexasDrumsBoldFontOfSize:16];
        cell.textLabel.textColor = [UIColor TexasDrumsGrayColor];
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

    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", profile.firstname, profile.lastname];
    
    return cell;
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressBookMemberViewController *ABMVC = [[AddressBookMemberViewController alloc] init];
    ABMVC.profile = [[full_name valueForKey:[[[full_name allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:ABMVC animated:YES];
    [ABMVC release];
}

#pragma mark - TexasDrumsRequest Delegate Methods

- (void)request:(TexasDrumsRequest *)request receivedData:(id)data {
    TDLog(@"Address Book request succeeded.");
    
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
                TDLog(@"No address book entities found. Request returned: %@", [results objectForKey:@"status"]);
                [self dismissWithSuccess];
                return;
            }
        }
        
        TDLog(@"New address book entities found. Parsing..");
        // Deserialize JSON results and parse them into Music objects.
        [self parseAddressBookData:results];
    }
    
    [self dismissWithSuccess];
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    TDLog(@"Address Book request error: %@", error);
    
    // Show error message.
    [self dismissWithError];
}



@end
