//
//  PaymentViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 9/26/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "PaymentViewController.h"
#import "CJSONDeserializer.h"
#import "TexasDrumsGetAccounts.h"
#import "TexasDrumsGetPaymentUpdate.h"

@implementation PaymentViewController

@synthesize paymentTable, memberList;

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Google Analytics
    [[GANTracker sharedTracker] trackPageview:@"Payment (PaymentView)" withError:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Website Dues"];
    
    // Set properties.
    self.paymentTable.separatorColor = [UIColor darkGrayColor];
    self.paymentTable.alpha = 0.0f;

    // Allocate things as necessary.
    if(memberList == nil){
        memberList = [[NSMutableArray alloc] init];
    }
    
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
    // Fetch data from the server.
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
    //self.navigationItem.rightBarButtonItem = refresh;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [SVProgressHUD showErrorWithStatus:@"Could not fetch data."];
}

- (void)displayTable {
    [self.paymentTable reloadData];
    [UIView animateWithDuration:0.5f animations:^{
        if([memberList count] > 0){
            self.paymentTable.alpha = 1.0f;
        }
        else {
            self.paymentTable.alpha = 0.0f;
        }
    }];
}

#pragma mark - Data Methods

- (void)connect {
    [self hideRefreshButton];
    [SVProgressHUD showWithStatus:@"Loading..."];
    TexasDrumsGetAccounts *get = [[TexasDrumsGetAccounts alloc] initWithUsername:_Profile.username andPassword:_Profile.password];
    get.delegate = self;
    [get startRequest];
}

- (void)parsePaymentData:(NSDictionary *)results {
    for(NSDictionary *item in results){
        Profile *profile = [Profile createNewProfile:item];
        if(profile.valid && [profile.status isEqualToString:@"Current"]){
            [memberList addObject:profile];
        }
    }
    
    [self sortMembersByName];
    [self displayTable];
}

- (void)sortMembersByName {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"firstname" ascending:YES];
    [memberList sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [descriptor release];
}

- (void)updateUser:(NSString *)user withPayment:(NSNumber *)paid {
    TexasDrumsGetPaymentUpdate *get = [[TexasDrumsGetPaymentUpdate alloc] initWithUsername:_Profile.username andPassword:_Profile.password andUser:user andPaid:paid];
    get.delegate = self;
    [get startRequest];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [memberList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont TexasDrumsBoldFontOfSize:16];
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uitableviewselection-orange-44.png"]] autorelease];
    }
    
    Profile *member = [memberList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", member.firstname, member.lastname];
    if(member.paid){
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.textLabel.textColor = [UIColor TexasDrumsGrayColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    Profile *profile = [memberList objectAtIndex:indexPath.row];
    
    NSString *user = profile.username;
    
    if(cell.accessoryType == UITableViewCellAccessoryNone){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        
        if([user isEqualToString:_Profile.username]){
            _Profile.paid = TRUE;
        }
        
        [self updateUser:user withPayment:[NSNumber numberWithInt:1]];
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor TexasDrumsGrayColor];
        
        if([user isEqualToString:_Profile.username]){
            _Profile.paid = FALSE;
        }
        
        [self updateUser:user withPayment:[NSNumber numberWithInt:0]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)request:(TexasDrumsRequest *)request receivedData:(id)data {
    TDLog(@"Request succeeded.");
    
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:data error:&error];
    
    if([results count] > 0){
        if([request isMemberOfClass:[TexasDrumsGetAccounts class]]) {
            // Check if the response is just a dictionary value of one.
            // This implies that the key value pair follows the format:
            // status -> 'message'
            // We use respondsToSelector since the API returns a dictionary
            // of length one for any status messages, but an array of
            // dictionary responses for valid data.
            // CJSONDeserializer interprets actual data as NSArrays.
            if([results respondsToSelector:@selector(objectForKey:)] ){
                if([[results objectForKey:@"status"] isEqualToString:_403_UNKNOWN_ERROR]) {
                    TDLog(@"No account entities found. Request returned: %@", [results objectForKey:@"status"]);
                    [self dismissWithSuccess];
                    return;
                }
            }

            TDLog(@"New account entities found. Parsing..");
            // Deserialize JSON results and parse them into Profile objects.
            [self parsePaymentData:results];
        }
        else if([request isMemberOfClass:[TexasDrumsGetPaymentUpdate class]]) {
            if([results respondsToSelector:@selector(objectForKey:)] ){
                if([[results objectForKey:@"status"] isEqualToString:_200_OK]) {
                    TDLog(@"Response received for payment update.");
                    [self dismissWithSuccess];
                    return;
                }
                else {
                    TDLog(@"Request failed. Request returned: %@", [results objectForKey:@"status"]);
                }
            } 
        }
    }
    
    [self dismissWithSuccess];
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    TDLog(@"Request error: %@", error);
    
    // Show error message.
    [self dismissWithError];
}

@end
