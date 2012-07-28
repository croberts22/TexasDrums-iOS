//
//  AddressBookMemberViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 4/25/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "AddressBookMemberViewController.h"
#import "Profile.h"

@interface AddressBookMemberViewController ()

@end

@implementation AddressBookMemberViewController

@synthesize member_name, member_header, member_status, profile, member_contact;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [[GANTracker sharedTracker] trackPageview:@"Address Book (AddressBookMemberView)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.member_name.text = [NSString stringWithFormat:@"%@ %@", profile.firstname, profile.lastname];
    self.member_status.text = [NSString stringWithFormat:@"%@ Member", profile.status];
    self.member_header.text = [NSString stringWithFormat:@"%@ (%@)", profile.section, profile.years];
    // Do any additional setup after loading the view from its nib.
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ProfileCell = @"Profile";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileCell];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ProfileCell] autorelease];
        }
    
    
    // Configure the cell...
    cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:12];
    cell.textLabel.textColor = [UIColor orangeColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Georgia" size:14];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.minimumFontSize = 10.0f;
    
    //UITableViewCell properties
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    if(indexPath.section == 0){
        switch(indexPath.row){
            case 0:
                cell.detailTextLabel.text = profile.email;
                cell.textLabel.text = @"Email";
                cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_table_cell.png"]] autorelease];
                ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"top_table_cell.png"];
                cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_table_cell.png"]] autorelease];
                ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"top_table_cell.png"];
                break;
            case 1:
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@-%@", 
                                             [profile.phonenumber substringWithRange:NSMakeRange(0, 3)],
                                             [profile.phonenumber substringWithRange:NSMakeRange(3, 3)],
                                             [profile.phonenumber substringWithRange:NSMakeRange(6, 4)]];
                cell.textLabel.text = @"Phone";
                cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_table_cell.png"]] autorelease];
                ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
                cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_table_cell.png"]] autorelease];
                ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
                break;
            default:
                break;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch(actionSheet.tag){
        case 1:
            if(buttonIndex == 0){ //User wants to send an email
                if(DEBUG_MODE) TDLog(@"User accepts email response. Pushing modal view only if user has configured mail client...");
                //if mail client is configured, set up modal view and present it to the user.
                if([MFMailComposeViewController canSendMail]){
                    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
                    mailVC.mailComposeDelegate = self;
                    [mailVC setToRecipients:[NSArray arrayWithObject:profile.email]];
                    [self presentModalViewController:mailVC animated:YES];
                    [mailVC release];
                }
                else{ //user has not set up mail.
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
            else { //user declines
                if(DEBUG_MODE) TDLog(@"User declined email response. Rolling back to address book member screen.");
            }
            break;
        case 2:
            if(buttonIndex == 0){
                if(DEBUG_MODE) TDLog(@"User accepted phone response. Switching to Phone app and dialing...");
                //this must be done on a device. will not work in a simulator.
                NSString *telephoneStr = [NSString stringWithFormat:@"tel:%@", profile.phonenumber];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telephoneStr]];
            }
            else {
                if(DEBUG_MODE) TDLog(@"User declined phone response. Rolling back to address book member screen.");
            }
            
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        if(indexPath.row == 0){ //email
            //prompt the user on whether or not he/she would like to email this person.
            //event captured by UIActionSheetDelegate method.
            if(DEBUG_MODE) TDLog(@"Prompting user for sending %@ an email.", profile.firstname);
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Would you like to send an email to %@?", profile.firstname]
                                                                     delegate:self 
                                                            cancelButtonTitle:@"Nah." 
                                                       destructiveButtonTitle:nil 
                                                            otherButtonTitles:@"Yes!", nil];
            actionSheet.tag = 1;
            [actionSheet showFromTabBar:self.parentViewController.tabBarController.tabBar];
            [actionSheet release];
        }
        else if(indexPath.row == 1){ //phone
            if(DEBUG_MODE) TDLog(@"Prompting user for calling %@.", profile.firstname);
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Would you like to call %@?", profile.firstname]
                                                                     delegate:self 
                                                            cancelButtonTitle:@"Nah." 
                                                       destructiveButtonTitle:nil 
                                                            otherButtonTitles:@"Yes!", nil];
            actionSheet.tag = 2;
            [actionSheet showFromTabBar:self.parentViewController.tabBarController.tabBar];
            [actionSheet release];
        }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}

@end
