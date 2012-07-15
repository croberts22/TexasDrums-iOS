//
//  PaymentViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 9/26/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "PaymentViewController.h"
#import "CJSONDeserializer.h"
#import "Profile.h"
#import "GANTracker.h"

@implementation PaymentViewController

@synthesize paymentTable, memberList, indicator;

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

- (void)viewWillAppear:(BOOL)animated {
    [[GANTracker sharedTracker] trackPageview:@"Payment (PaymentView)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Website Dues"];
    self.paymentTable.separatorColor = [UIColor darkGrayColor];
    self.paymentTable.alpha = 0.0f;

    if(memberList == nil){
        memberList = [[NSMutableArray alloc] init];
    }
    [indicator startAnimating];
    [self performSelectorInBackground:@selector(fetchMembers) withObject:nil];
}

- (void)fetchMembers {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSError *error = nil;
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&username=%@&password=%@", TEXAS_DRUMS_API_ACCOUNTS, TEXAS_DRUMS_API_KEY, _Profile.username, _Profile.password];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //store results into dictionary
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:response error:&error];
    TDLog(@"%@", results);
    for(NSDictionary *member in results){
        if([[member objectForKey:@"status"] isEqualToString:@"Current"]){
            Profile *member_profile = [[Profile alloc] init];
            
            member_profile.firstname = [member objectForKey:@"firstname"];
            member_profile.lastname = [member objectForKey:@"lastname"];
            member_profile.username = [member objectForKey:@"username"];
            member_profile.paid = [[member objectForKey:@"paid"] boolValue];
            
            [memberList addObject:member_profile];
            [member_profile release];
        }
    }
    [self sortMembersByName];
    [self performSelectorOnMainThread:@selector(displayTable) withObject:nil waitUntilDone:NO];
    [pool release];
}

- (void)sortMembersByName {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"firstname" ascending:YES];
    [memberList sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [descriptor release];
}

- (void)updateUser:(NSString *)user withPayment:(int)paid {   
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&username=%@&paid=%d", TEXAS_DRUMS_API_UPDATE_PAYMENT, TEXAS_DRUMS_API_KEY, user, paid];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *get = [[[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding] autorelease]; 
    TDLog(@"Payment response from server: %@", get);
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [memberList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    //UITableViewCell Properties
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:16.0f];
    cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uitableviewselection-orange-44.png"]] autorelease]; 
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[memberList objectAtIndex:indexPath.row] firstname], [[memberList objectAtIndex:indexPath.row] lastname]];
    if([[memberList objectAtIndex:indexPath.row] paid]){
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)displayTable {
    float delay = 1.0f;
    [paymentTable reloadData];
    [UIView beginAnimations:@"displayPaymentTable" context:NULL];
    [UIView setAnimationDelay:delay];
    self.paymentTable.alpha = 1.0f;
    self.indicator.alpha = 0.0f;
    [UIView commitAnimations];
    [self.indicator performSelector:@selector(stopAnimating) withObject:nil afterDelay:delay+.25];
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *user = [[memberList objectAtIndex:indexPath.row] username];
    if(cell.accessoryType == UITableViewCellAccessoryNone){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        if([[[memberList objectAtIndex:indexPath.row] username] isEqualToString:_Profile.username]){
            _Profile.paid = TRUE;
        }
        [self updateUser:user withPayment:1];
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor whiteColor];
        if([[[memberList objectAtIndex:indexPath.row] username] isEqualToString:_Profile.username]){
            _Profile.paid = FALSE;
        }
        [self updateUser:user withPayment:0];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
