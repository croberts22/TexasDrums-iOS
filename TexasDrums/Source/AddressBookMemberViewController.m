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

#pragma mark - Memory Management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    // Google Analytics
    [[GANTracker sharedTracker] trackPageview:@"Address Book (AddressBookMemberView)" withError:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set properties.
    self.view.backgroundColor = [UIColor clearColor];
    self.member_name.text = [NSString stringWithFormat:@"%@ %@", profile.firstname, profile.lastname];
    self.member_status.text = [NSString stringWithFormat:@"%@ Member", profile.status];
    self.member_header.text = [NSString stringWithFormat:@"%@ (%@)", profile.section, profile.years];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *ProfileCell = @"Profile";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileCell];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ProfileCell] autorelease];
        
        cell.textLabel.font = [UIFont TexasDrumsFontOfSize:12];
        cell.textLabel.textColor = [UIColor TexasDrumsOrangeColor];
        cell.detailTextLabel.font = [UIFont TexasDrumsFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor TexasDrumsGrayColor];
        cell.detailTextLabel.minimumFontSize = 10.0f;
        
        //UITableViewCell properties
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        cell.backgroundView = [[[UIImageView alloc] init] autorelease];
        cell.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];
    }    
    
    if(indexPath.section == 0){
        switch(indexPath.row){
            case 0:
                cell.detailTextLabel.text = profile.email;
                cell.textLabel.text = @"Email";
                ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"top_table_cell.png"];
                ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"top_table_cell.png"];
                break;
            case 1:
                cell.detailTextLabel.text = [NSString parsePhoneNumber:profile.phonenumber];
                cell.textLabel.text = @"Phone";
                ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
                ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
                break;
            default:
                break;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DEFAULT_ROW_HEIGHT;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){ 
        // User wanst to send an email.
        TDLog(@"Prompting user for sending %@ an email.", profile.firstname);
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Would you like to send an email to %@?", profile.firstname]
                                                                 delegate:self
                                                        cancelButtonTitle:@"Nah."
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Yes!", nil];
        actionSheet.tag = 1;
        [actionSheet showFromTabBar:self.parentViewController.tabBarController.tabBar];
        [actionSheet release];
    }
    else if(indexPath.row == 1){
        // User wants to call.
        TDLog(@"Prompting user for calling %@.", profile.firstname);
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

#pragma mark - UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSIndexPath *indexPath = [self.member_contact indexPathForSelectedRow];
    [self.member_contact deselectRowAtIndexPath:indexPath animated:YES];
    
    switch(actionSheet.tag){
        case 1:
            // User is wanting to send an email.
            if(buttonIndex == 0){
                TDLog(@"User accepts email response. Pushing modal view only if user has configured mail client...");
                
                if([MFMailComposeViewController canSendMail]){
                    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
                    mailVC.mailComposeDelegate = self;
                    mailVC.navigationBar.tintColor = [UIColor colorWithRed:215.0/255.0
                                                                     green:127.0/255.0
                                                                      blue:0.0/255.0
                                                                     alpha:1.0];
                    [mailVC setToRecipients:[NSArray arrayWithObject:profile.email]];
                    [self presentModalViewController:mailVC animated:YES];
                    [mailVC release];
                }
                else{
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
            // User does not want to send an email.
            else {
                TDLog(@"User declined email response. Rolling back to address book member screen.");
            }
            break;
        case 2:
            // User wants to call someone.
            if(buttonIndex == 0){
                TDLog(@"User accepted phone response. Switching to Phone app and dialing...");
                // You must test this out on a device, not a simulator.
                NSString *telephoneStr = [NSString stringWithFormat:@"tel:%@", profile.phonenumber];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telephoneStr]];
            }
            // User does not want to call someone.
            else {
                TDLog(@"User declined phone response. Rolling back to address book member screen.");
            }
    }
}

#pragma mark - MFMailComposeViewController Delegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}

@end
