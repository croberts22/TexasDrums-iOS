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

@interface PaymentViewController() {
    TexasDrumsGetAccounts *getAccounts;
    TexasDrumsGetPaymentUpdate *getPayment;
}

@property (nonatomic, retain) TexasDrumsGetAccounts *getAccounts;
@property (nonatomic, retain) TexasDrumsGetPaymentUpdate *getPayment;

@end

@implementation PaymentViewController

@synthesize getAccounts, getPayment;
@synthesize paymentTable, memberList;

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    self.getAccounts.delegate = nil;
    [self.getAccounts cancelRequest];
    self.getPayment.delegate = nil;
    [self.getPayment cancelRequest];
    [getAccounts release], getAccounts = nil;
    [getPayment release], getPayment = nil;
    [paymentTable release], paymentTable = nil;
    [memberList release], memberList = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
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
    self.getAccounts = [[TexasDrumsGetAccounts alloc] initWithUsername:[UserProfile sharedInstance].username
                                                           andPassword:[UserProfile sharedInstance].hash
                                                 getCurrentMembersOnly:YES];
    self.getAccounts.delegate = self;
    [self.getAccounts startRequest];
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
    self.getPayment = [[TexasDrumsGetPaymentUpdate alloc] initWithUsername:[UserProfile sharedInstance].username
                                                               andPassword:[UserProfile sharedInstance].hash
                                                                   andUser:user
                                                                   andPaid:paid];
    self.getPayment.delegate = self;
    [self.getPayment startRequest];
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
        cell.accessoryView = [UIView TexasDrumsCheckmarkAccessoryView];
    }
    else{
        cell.textLabel.textColor = [UIColor TexasDrumsGrayColor];
        cell.accessoryView = nil;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    Profile *profile = [memberList objectAtIndex:indexPath.row];
    
    NSString *user = profile.username;
    
    if(cell.accessoryView == nil){
        cell.accessoryView = [UIView TexasDrumsCheckmarkAccessoryView];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        
        if([user isEqualToString:[UserProfile sharedInstance].username]){
            [UserProfile sharedInstance].paid = TRUE;
        }
        
        profile.paid = YES;
        [self updateUser:user withPayment:[NSNumber numberWithInt:1]];
    }
    else{
        cell.accessoryView = nil;
        cell.textLabel.textColor = [UIColor TexasDrumsGrayColor];
        
        if([user isEqualToString:[UserProfile sharedInstance].username]){
            [UserProfile sharedInstance].paid = FALSE;
        }
        
        profile.paid = NO;
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
