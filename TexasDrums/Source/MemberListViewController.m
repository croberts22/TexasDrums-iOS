//
//  MemberListViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 8/4/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "MemberListViewController.h"
#import "TexasDrumsGetAccounts.h"
#import "CJSONDeserializer.h"

@interface MemberListViewController ()

@end

@implementation MemberListViewController

@synthesize memberList, currentSelection;

static NSMutableArray *members = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Who's In?"];
    
    self.memberList.separatorColor = [UIColor darkGrayColor];
    
    // Allocate things as necessary.
    // These will only be allocated once, since they are static.
    // There's no need to fetch for this data multiple times.
    if(members == nil) {
        members = [[NSMutableArray alloc] init];
        self.memberList.alpha = 0.0f;
        [self connect];
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
    [self.memberList reloadData];
    [UIView animateWithDuration:0.5f animations:^{
        self.memberList.alpha = 1.0f;
    }];
}

#pragma mark - Data Methods

- (void)connect {
    [self hideRefreshButton];
    [SVProgressHUD showWithStatus:@"Loading..."];
    TexasDrumsGetAccounts *get = [[TexasDrumsGetAccounts alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                     andPassword:[UserProfile sharedInstance].hash
                                                           getCurrentMembersOnly:YES];
    get.delegate = self;
    [get startRequest];
}

- (void)parseMemberList:(NSDictionary *)results {
    for(NSDictionary *item in results){
        Profile *profile = [Profile createNewProfile:item];
        if(profile.valid){
            [members addObject:profile];
        }
    }
    
    [self sortMembersByName];
    [self displayTable];
}

- (void)sortMembersByName {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"firstname" ascending:YES];
    [members sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [descriptor release];
}

#pragma mark - Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [members count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DEFAULT_ROW_HEIGHT;
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
    
    profile = [members objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", profile.firstname, profile.lastname];
    
    return cell;
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - TexasDrumsRequest Delegate Methods

- (void)request:(TexasDrumsRequest *)request receivedData:(id)data {
    TDLog(@"Member List request succeeded.");
    
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
        
        TDLog(@"New member entities found. Parsing..");
        // Deserialize JSON results and parse them into Music objects.
        [self parseMemberList:results];
    }
    
    [self dismissWithSuccess];
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    TDLog(@"Member List request error: %@", error);
    
    // Show error message.
    [self dismissWithError];
}


@end
