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
#import "TexasDrumsGetAccounts.h"

@interface AddressBookViewController() {
    TexasDrumsGetAccounts *getAccounts;
}

@property (nonatomic, retain) TexasDrumsGetAccounts *getAccounts;

@end

@implementation AddressBookViewController

static NSMutableArray *addressBook = nil;
static NSMutableDictionary *full_name = nil;

@synthesize getAccounts;
@synthesize addressBookTable;

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
    self.getAccounts.delegate = nil;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = [self.addressBookTable indexPathForSelectedRow];
    if(indexPath) {
        [self.addressBookTable deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    [self.getAccounts cancelRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Address Book"];
    
    // Set properties.
    self.addressBookTable.separatorColor = [UIColor darkGrayColor];
    
    // Allocate things as necessary.
    // These will only be allocated once, since they are static.
    // There's no need to fetch for this data multiple times.
    if(addressBook == nil && full_name == nil){
        addressBook = [[NSMutableArray alloc] init];
        full_name = [[NSMutableDictionary alloc] init];
    
        self.addressBookTable.alpha = 0.0f;
        
        [self connect];
    }
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
    [self.addressBookTable reloadData];
    [UIView animateWithDuration:0.5f animations:^{
        self.addressBookTable.alpha = 1.0f;
    }];
}

#pragma mark - Data Methods

- (void)connect {
    [self hideRefreshButton];
    [SVProgressHUD showWithStatus:@"Loading..."];
    self.getAccounts = [[TexasDrumsGetAccounts alloc] initWithUsername:[UserProfile sharedInstance].username
                                                           andPassword:[UserProfile sharedInstance].hash
                                                 getCurrentMembersOnly:NO];
    self.getAccounts.delegate = self;
    [self.getAccounts startRequest];
}

- (void)parseAddressBookData:(NSDictionary *)results {    
    for(NSDictionary *item in results){
        Profile *profile = [Profile createNewProfile:item];
        if(profile.valid){
            [addressBook addObject:profile];
        }
    }
    
    [self sortMembersByName];
    [self displayTable];
}

- (void)sortMembersByName {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"firstname" ascending:YES];
    [addressBook sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    
    //now, grab all alpha characters
    [self grabCharacters];
}

- (void)grabCharacters {
    BOOL found;
    
    for (Profile *this_profile in addressBook){
        NSString *c = this_profile.alphabet_first;
        found = FALSE;
        for (NSString *str in [full_name allKeys]){
            if ([str isEqualToString:c]){
                found = TRUE;
            }
        }
        if (!found){
            [full_name setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
    
    for (Profile *this_profile in addressBook){
        [[full_name objectForKey:this_profile.alphabet_first] addObject:this_profile];
    }
    
    for (NSString *key in [full_name allKeys]){
        //Name Table
        [[full_name objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"firstname" ascending:YES]]];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[full_name allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[full_name allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[full_name valueForKey:[[[full_name allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DEFAULT_ROW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle;
    
    sectionTitle = [[[full_name allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    
    UIView *header = [UIView TexasDrumsAddressBookTableHeaderViewWithTitle:sectionTitle];
    
	return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uitableviewselection-orange-44.png"]];
        
        cell.textLabel.font = [UIFont TexasDrumsBoldFontOfSize:16];
        cell.textLabel.textColor = [UIColor TexasDrumsGrayColor];
    }
    
    Profile *profile;

    profile = [[full_name valueForKey:[[[full_name allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", profile.firstname, profile.lastname];
    
    return cell;
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressBookMemberViewController *ABMVC = [[AddressBookMemberViewController alloc] init];
    ABMVC.profile = [[full_name valueForKey:[[[full_name allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:ABMVC animated:YES];
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
