//
//  InfoViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 8/8/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "InfoViewController.h"
#import "AboutUsViewController.h"
#import "FAQViewController.h"
#import "StaffViewController.h"
#import "AboutThisAppViewController.h"

@implementation InfoViewController

@synthesize aboutTable;

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
    [self.aboutTable release];
    [super dealloc];
}

#pragma mark - View lifecycle

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

- (void)viewWillAppear:(BOOL)animated {
    // Google Analytics
    [[GANTracker sharedTracker] trackPageview:@"Info (InfoView)" withError:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Info"];
    
    // Set properties.
    self.aboutTable.scrollEnabled = NO;
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return HEADER_HEIGHT;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle;
    if(section == 0){
        sectionTitle = @"About Texas Drums";
    }
    else if(section == 1){
        sectionTitle = @"About This App ";
    }
    
    UIView *header = [UIView TexasDrumsGroupedTableHeaderViewWithTitle:sectionTitle andAlignment:UITextAlignmentLeft];
    
	return header;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 1){
        UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 10)] autorelease];
        UILabel *headerTitle = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)] autorelease];
        headerTitle.textAlignment = UITextAlignmentCenter;
        headerTitle.textColor = [UIColor darkGrayColor];
        //headerTitle.shadowColor = [UIColor blackColor];
        headerTitle.shadowOffset = CGSizeMake(0, 1);
        headerTitle.font = [UIFont fontWithName:@"Georgia-Bold" size:14];
        headerTitle.backgroundColor = [UIColor clearColor];
        headerTitle.text =[NSString stringWithFormat:@"You're using version %@!", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]];
        [containerView addSubview:headerTitle];
        
        return containerView;
    }
    else return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 3;
    }
    else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    //configure cell text
    if(indexPath.section == 0){
        switch(indexPath.row){
            case 0:
                cell.textLabel.text = @"About Us";
                break;
            case 1:
                cell.textLabel.text = @"FAQ";
                break;
            case 2:
                cell.textLabel.text = @"Section Leaders And Staff";
                break;
            default:
                break;
        }
    }
    else{
        switch(indexPath.row){
            case 0:
                cell.textLabel.text = @"About This App";
                break;
            case 1:
                cell.textLabel.text = @"Contact The Developers";
                break;
            default:
                break;
        }
    }

    //configure cell font, color, and background    
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:16];    
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.clipsToBounds = YES;
    
    
    // MAN THIS IS SO SLOPPY.
    if(indexPath.section == 0){
        //configure cell background images
        if(indexPath.row == 0){
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_table_cell.png"]] autorelease];
            ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"top_table_cell.png"];
        }
        if(indexPath.row == 1){
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell.png"]] autorelease];
            ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"table_cell.png"];
        }
        if(indexPath.row == 2){
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_table_cell.png"]] autorelease];
            ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
        }
        
        //configure cell selection background images here
        if(indexPath.row == 0){
            cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_table_cell.png"]] autorelease];
            ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"top_table_cell.png"];
        }
        if(indexPath.row == 1){
            cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell.png"]] autorelease];
            ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"table_cell.png"];
        }
        if(indexPath.row == 2){
            cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_table_cell.png"]] autorelease];
            ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
        }
    }
    else{
        //configure cell background images
        if(indexPath.row == 0){
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_table_cell.png"]] autorelease];
            ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"top_table_cell.png"];
        }
        if(indexPath.row == 1){
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_table_cell.png"]] autorelease];
            ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
        }
        
        //configure cell selection background images here
        if(indexPath.row == 0){
            cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_table_cell.png"]] autorelease];
            ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"top_table_cell.png"];
        }
        if(indexPath.row == 1){
            cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_table_cell.png"]] autorelease];
            ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
        }
    }
    
    
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.aboutTable deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            AboutUsViewController *AUVC = [[AboutUsViewController alloc] initWithNibName:@"AboutUsView" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:AUVC animated:YES];
            [AUVC release];
        }
        else if(indexPath.row == 1){
            FAQViewController *FVC = [[FAQViewController alloc] initWithNibName:@"FAQView" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:FVC animated:YES];
            [FVC release];
        }
        else if(indexPath.row == 2){
            StaffViewController *SVC = [[StaffViewController alloc] initWithNibName:@"StaffView" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:SVC animated:YES];
            [SVC release];
        }
    }
    else if(indexPath.section == 1){
        if(indexPath.row == 0){
            AboutThisAppViewController *ATAVC = [[AboutThisAppViewController alloc] initWithNibName:@"AboutThisAppView" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:ATAVC animated:YES];
            [ATAVC release];
        }
        else if(indexPath.row == 1){
            if([MFMailComposeViewController canSendMail]){
                MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
                mailVC.mailComposeDelegate = self;
                [mailVC setToRecipients:[NSArray arrayWithObject:@"support@texasdrums.com"]];
                [mailVC setSubject:@"Texas Drums (iOS) Comments"];
                [self presentModalViewController:mailVC animated:YES];
                [mailVC release];
            }
        }
    }

}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}


@end
