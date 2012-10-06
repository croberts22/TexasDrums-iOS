//
//  StaffViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 1/13/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "StaffViewController.h"
#import "StaffMember.h"
#import "CJSONDeserializer.h"
#import "TexasDrumsTableViewCell.h"
#import "StaffMemberViewController.h"
#import "TexasDrumsGetStaff.h"

@interface StaffViewController()

- (void)displayTable;
- (void)parseStaffData:(NSDictionary *)results;

@end

@implementation StaffViewController

@synthesize staffTable, staff;

#pragma mark - Memory Management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [staffTable release], staffTable = nil;
    [staff release], staff = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Google Analytics
    [[GANTracker sharedTracker] trackPageview:[[self class] description] withError:nil];
    
    NSIndexPath *indexPath = [self.staffTable indexPathForSelectedRow];
    if(indexPath) {
        [self.staffTable deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Staff"];
    
    // Allocate things as necessary.
    if(staff == nil){
        staff = [[NSMutableArray alloc] init];
    }

    // Set properties.
    self.staffTable.backgroundColor = [UIColor clearColor];
    self.staffTable.separatorColor = [UIColor grayColor];
    self.staffTable.alpha = 0.0f;
    
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
    // Fetch roster from the server.
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
    [self.staffTable reloadData];
    [UIView animateWithDuration:0.5f animations:^{
        self.staffTable.alpha = 1.0f;
    }];
}

#pragma mark - Data Methods

- (void)connect {
    [self hideRefreshButton];
    [SVProgressHUD showWithStatus:@"Loading..."];
    TexasDrumsGetStaff *get = [[TexasDrumsGetStaff alloc] init];
    get.delegate = self;
    [get startRequest];
}

- (void)parseStaffData:(NSDictionary *)results {
    for(NSDictionary *item in results){
        StaffMember *member = [StaffMember createNewStaffMember:item];
        [staff addObject:member];
    }
    
    [self displayTable]; 
}

#pragma mark - UITableView Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [staff count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return STAFF_ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    TexasDrumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[TexasDrumsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
        cell.textLabel.font = [UIFont TexasDrumsBoldFontOfSize:18];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }

        StaffMember *staffMember = [staff objectAtIndex:indexPath.row];
    
    // Asynchronously fetch the Staff image; in the mean time, use a thumbnail until the image is fetched.
    // NOTE: The API contains a global variable that determines which year to fetch.  The API was implemented this
    // way so we could dynamically alter the Staff page without having to push out a new update (fixed in v1.1).
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DOMAIN_PATH, staffMember.image_url]];
    
    [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Thumbnail.png"]];
    
    cell.textLabel.text = staffMember.fullname;
    cell.detailTextLabel.text = staffMember.instrument;
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StaffMemberViewController *SMVC = [[[StaffMemberViewController alloc] initWithNibName:@"StaffMemberViewController" bundle:[NSBundle mainBundle]] autorelease];
    SMVC.member = [staff objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:SMVC animated:YES];
}

#pragma mark - TexasDrumsRequestDelegate Methods

- (void)request:(TexasDrumsRequest *)request receivedData:(id)data {
    TDLog(@"Obtained staff members successfully.");
    
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
                TDLog(@"No staff data found. Request returned: %@", [results objectForKey:@"status"]);
                [self dismissWithSuccess];
                return;
            }
        }
        
        TDLog(@"New staff data found. Parsing..");
        // Deserialize JSON results and parse them into StaffMember objects.
        
        [self parseStaffData:results];
    }
    
    [self dismissWithSuccess];
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    TDLog(@"Request error: %@", error);
    
    // Show refresh button and error message.
    [self dismissWithError];
}


@end
