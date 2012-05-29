//
//  SingleMemberView.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/27/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "SingleMemberView.h"
#import "TexasDrumsGroupedTableViewCell.h"
#import "GANTracker.h"

#define SMALL_FONT_SIZE (12.0f)
#define FONT_SIZE (14.0f)
#define CELL_CONTENT_WIDTH (320.0f)
#define CELL_CONTENT_MARGIN (10.0f)

@implementation SingleMemberView

@synthesize memberData, memberNameCell, name, firstname, nickname, lastname, data, classification, amajor, hometown, quote, phonenumber, email, categories;

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
    [memberNameCell release];
    [memberData release];
    [name release];
    [firstname release];
    [nickname release];
    [lastname release];
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
    [[GANTracker sharedTracker] trackPageview:@"Member (SingleMemberView)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.memberData.backgroundColor = [UIColor clearColor];
    if(categories == nil){
        categories = [[NSArray alloc] initWithObjects:@"Year", @"Major", @"Hometown", @"Quote", @"Email", @"Phone", nil];
    }
    NSString *combinedname;
    if(![nickname isEqualToString:@""]){
        combinedname = [NSString stringWithFormat:@"%@ \"%@\" %@", firstname, nickname, lastname];
    }
    else{
        combinedname = [NSString stringWithFormat:@"%@ %@", firstname, lastname];
    }
    
    data = [[NSArray alloc] initWithObjects:combinedname, classification, amajor, hometown, quote, email, phonenumber, nil];
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:@"member"]){
        return 3;
    }
    else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0){
        return 1;
    }
    else if(section == 1){
        return 4;
    }
    else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellName = @"Name";
    static NSString *CellData = @"Profile";
    
    UITableViewCell *cell;
    if(indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:CellName];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellName] autorelease];
        }
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:CellData];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellData] autorelease];
        }
    }
    
    //UITableViewCell Properties
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.textColor = [UIColor orangeColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Georgia" size:FONT_SIZE];
    cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:SMALL_FONT_SIZE];
    
    if(indexPath.section == 0){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:16]; 
        cell.textLabel.text = [data objectAtIndex:0];
    }
    else{
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;    
        
        if(indexPath.section == 1){
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = [categories objectAtIndex:indexPath.row];
            if([[data objectAtIndex:indexPath.row+1] isEqualToString:@""]){
                cell.detailTextLabel.text = @"n/a";
            }
            else{
                cell.detailTextLabel.text = [data objectAtIndex:indexPath.row+1];
            }
        }
        else{
            cell.textLabel.text = [categories objectAtIndex:indexPath.row+4];
            cell.detailTextLabel.text = [data objectAtIndex:indexPath.row+5];
            //cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uitableviewselection-orange-44.png"]] autorelease];
            if([cell.detailTextLabel.text isEqualToString:@"n/a"]){
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
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
    //the UILabel is 280px in width.
    //so, the constraint must be WIDTH - ((MARGIN*2)*2)
    //i.e., 320px - (((10px*2)*2)) = 280px
    if(indexPath.section == 0){
        return 100.0f;
    }
    else if(indexPath.section == 1){
        if(indexPath.row == 3){
            NSString *text = [data objectAtIndex:indexPath.row+1];
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Georgia" size:FONT_SIZE+4] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            NSLog(@"%f", size.height);
            CGFloat height = MAX(size.height, 44.0f);
            NSLog(@"%f", height + CELL_CONTENT_MARGIN * 2);
            return height + CELL_CONTENT_MARGIN * 2;
            //max(size.height, 44.0f); // + CELL_CONTENT_MARGIN*2;
        }
        else{
            return 44.0f;
        }
    }
    else return 44.0f;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch(actionSheet.tag){
        case 1:
            if(buttonIndex == 0){ //User wants to send an email
                if(DEBUG_MODE) NSLog(@"User accepts email response. Pushing modal view only if user has configured mail client...");
                //if mail client is configured, set up modal view and present it to the user.
                if([MFMailComposeViewController canSendMail]){
                    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
                    mailVC.mailComposeDelegate = self;
                    [mailVC setToRecipients:[NSArray arrayWithObject:email]];
                    [self presentModalViewController:mailVC animated:YES];
                    [mailVC release];
                }
                else{ //user has not set up mail.
                    NSLog(@"Mail client not configured.");
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
               if(DEBUG_MODE) NSLog(@"User declined email response. Rolling back to member screen.");
            }
            break;
        case 2:
            if(buttonIndex == 0){
                if(DEBUG_MODE) NSLog(@"User accepted phone response. Switching to Phone app and dialing...");
                //this must be done on a device. will not work in a simulator.
                NSString *telephoneStr = [NSString stringWithFormat:@"tel:%@", phonenumber];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telephoneStr]];
            }
            else {
                if(DEBUG_MODE) NSLog(@"User declined phone response. Rolling back to member screen.");
            }

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.memberData deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 2){
        if([[[[self.memberData cellForRowAtIndexPath:indexPath] detailTextLabel] text] isEqualToString:@"n/a"]){
            return;
        }
        if(indexPath.row == 0){ //email
            //prompt the user on whether or not he/she would like to email this person.
            //event captured by UIActionSheetDelegate method.
            if(DEBUG_MODE) NSLog(@"Prompting user for sending %@ an email.", firstname);
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Would you like to send an email to %@?", firstname]
                                                                     delegate:self 
                                                            cancelButtonTitle:@"Nah." 
                                                       destructiveButtonTitle:nil 
                                                            otherButtonTitles:@"Yes!", nil];
            actionSheet.tag = 1;
            [actionSheet showFromTabBar:self.parentViewController.tabBarController.tabBar];
            [actionSheet release];
        }
        else if(indexPath.row == 1){ //phone
            if(DEBUG_MODE) NSLog(@"Prompting user for calling %@.", firstname);
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Would you like to call %@?", firstname]
                                                                     delegate:self 
                                                            cancelButtonTitle:@"Nah." 
                                                       destructiveButtonTitle:nil 
                                                            otherButtonTitles:@"Yes!", nil];
            actionSheet.tag = 2;
            [actionSheet showFromTabBar:self.parentViewController.tabBarController.tabBar];
            [actionSheet release];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}

@end
