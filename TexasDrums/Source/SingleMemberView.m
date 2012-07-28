//
//  SingleMemberView.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/27/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "SingleMemberView.h"
#import "TexasDrumsGroupedTableViewCell.h"
#import "RosterMember.h"

@implementation SingleMemberView

@synthesize member;
@synthesize memberData, memberName, data, categories;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [memberName release];
    [memberData release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Google Analytics
    [[GANTracker sharedTracker] trackPageview:@"Member (SingleMemberView)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set properties.
    self.memberData.backgroundColor = [UIColor clearColor];
    self.memberName.font = [UIFont TexasDrumsBoldFontOfSize:20];
    self.memberName.textColor = [UIColor TexasDrumsOrangeColor];
    self.memberName.textAlignment = UITextAlignmentCenter;
    self.memberName.lineBreakMode = UILineBreakModeTailTruncation;
    
    // Set up categories for the table cells.
    if(categories == nil){
        categories = [[NSArray alloc] initWithObjects:@"Year", @"Major", @"Hometown", @"Quote", @"Email", @"Phone", nil];
    }
    
    NSString *combined_name = [NSString stringWithFormat:@"%@ %@", member.firstname, member.lastname];
    
    // If member has a nickname, create the full name.
    if(![member.nickname isEqualToString:@""]){
        combined_name = [NSString stringWithFormat:@"%@ \"%@\" %@", member.firstname, member.nickname, member.lastname];
    }
    
    self.memberName.text = combined_name;
    
    // Allocate things as necessary.
    data = [[NSArray alloc] initWithObjects:member.year, member.amajor, member.hometown, member.quote, member.email, member.phone, nil];
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

#pragma mark - UITableView Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // If user is a member, display additional section for contact information.
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"member"]){
        return 2;
    }

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 4;
    }
    else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellData = @"Profile";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellData];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellData] autorelease];
    }
    
    //UITableViewCell Properties
    cell.detailTextLabel.textColor = [UIColor TexasDrumsGrayColor];
    cell.textLabel.textColor = [UIColor TexasDrumsOrangeColor];
    cell.detailTextLabel.font = [UIFont TexasDrumsFontOfSize:FONT_SIZE];
    cell.textLabel.font = [UIFont TexasDrumsFontOfSize:SMALL_FONT_SIZE];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;    
    
    if(indexPath.section == 0){
        cell.textLabel.text = [categories objectAtIndex:indexPath.row];
        if([[data objectAtIndex:indexPath.row] isEqualToString:@""]){
            cell.detailTextLabel.text = @"n/a";
        }
        else{
            cell.detailTextLabel.text = [data objectAtIndex:indexPath.row];
        }
    }
    else{
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.text = [categories objectAtIndex:indexPath.row+4];
        cell.detailTextLabel.text = [data objectAtIndex:indexPath.row+4];
        if([cell.detailTextLabel.text isEqualToString:@"n/a"]){
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }   
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.contentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 3){
        NSString *text = [data objectAtIndex:indexPath.row];
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        CGSize size = [text sizeWithFont:[UIFont TexasDrumsFontOfSize:FONT_SIZE+4] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat height = MAX(size.height, 44.0f) + CELL_CONTENT_MARGIN * 2;
        
        return height;
    }
    
    return 44.0f;

}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.memberData deselectRowAtIndexPath:indexPath animated:YES];
    
    // Display an action sheet based on what the user chose.
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self 
                                                    cancelButtonTitle:@"Nah." 
                                               destructiveButtonTitle:nil 
                                                    otherButtonTitles:@"Yes!", nil];
    
    if(indexPath.section == 1){
        if([[[[self.memberData cellForRowAtIndexPath:indexPath] detailTextLabel] text] isEqualToString:@"n/a"]){
            return;
        }
        if(indexPath.row == 0){ //email
            if(DEBUG_MODE) TDLog(@"Prompting user for sending %@ an email.", member.firstname);
            actionSheet.title = [NSString stringWithFormat:@"Would you like to send an email to %@?", member.firstname];
            actionSheet.tag = 1;
        }
        else if(indexPath.row == 1){ //phone
            if(DEBUG_MODE) TDLog(@"Prompting user for calling %@.", member.firstname);
            actionSheet.title = [NSString stringWithFormat:@"Would you like to call %@?", member.firstname];
            actionSheet.tag = 2;
        }

        [actionSheet showFromTabBar:self.parentViewController.tabBarController.tabBar];
        [actionSheet release];
    }
}

#pragma mark - UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch(actionSheet.tag){
        case 1:
            if(buttonIndex == 0){ // User wants to send an email.
                if(DEBUG_MODE) TDLog(@"User accepts email response. Pushing modal view only if user has configured mail client...");
                // If mail client is configured, set up modal view and present it to the user.
                if([MFMailComposeViewController canSendMail]){
                    
                    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
                    mailVC.mailComposeDelegate = self;
                    [mailVC setToRecipients:[NSArray arrayWithObject:member.email]];
                    [self presentModalViewController:mailVC animated:YES];
                    [mailVC release];
                    
                }
                else{ // User has not set up mail.
                    TDLog(@"Mail client not configured.");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" 
                                                                    message:@"You have not configured your mail client yet. Please open up the Mail app and configure your settings, and try again." 
                                                                   delegate:self 
                                                          cancelButtonTitle:@"Okay" 
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }
            }
            else { // User declines.
                if(DEBUG_MODE) TDLog(@"User declined email response. Rolling back to member screen.");
            }
            
            break;
            
        case 2:
            if(buttonIndex == 0){
                if(DEBUG_MODE) TDLog(@"User accepted phone response. Switching to Phone app and dialing...");
                // This must be done on a device. It will not work in a simulator.
                NSString *telephoneStr = [NSString stringWithFormat:@"tel:%@", member.phone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telephoneStr]];
            }
            else {
                if(DEBUG_MODE) TDLog(@"User declined phone response. Rolling back to member screen.");
            }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - MFMailComposeViewController Delegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}

@end
