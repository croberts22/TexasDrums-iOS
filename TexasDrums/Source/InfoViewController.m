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

#pragma mark - UITableView Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle;
    
    if(section == 0){
        sectionTitle = @"About Texas Drums";
    }
    else if(section == 1){
        sectionTitle = @"About This App";
    }
    
    UIView *header = [UIView TexasDrumsGroupedTableHeaderViewWithTitle:sectionTitle andAlignment:UITextAlignmentLeft];
    
	return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if(section == 1){
        return [UIView TexasDrumsVersionFooter];
    }
    else return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.textLabel.textColor = [UIColor TexasDrumsGrayColor];
        cell.textLabel.font = [UIFont TexasDrumsBoldFontOfSize:16];
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView.clipsToBounds = YES;
        
        // Since a cell's background views are not compatible with UIImageView,
        // set them both as UIImageView.
        cell.backgroundView = [[[UIImageView alloc] init] autorelease];
        cell.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];
    }

    UIImage *background;
    UIImage *selected_background;
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            cell.textLabel.text = @"About Us";
            background = [UIImage imageNamed:@"top_table_cell.png"];
            selected_background = [UIImage imageNamed:@"top_table_cell.png"];
        }
        if(indexPath.row == 1){
            cell.textLabel.text = @"FAQ";
            background = [UIImage imageNamed:@"table_cell.png"];
            selected_background = [UIImage imageNamed:@"table_cell.png"];
        }
        if(indexPath.row == 2){
            cell.textLabel.text = @"Section Leaders and Staff";
            background = [UIImage imageNamed:@"bottom_table_cell.png"];
            selected_background = [UIImage imageNamed:@"bottom_table_cell.png"];
        }
    }
    else{
        if(indexPath.row == 0){
            cell.textLabel.text = @"About This App";
            background = [UIImage imageNamed:@"top_table_cell.png"];
            selected_background = [UIImage imageNamed:@"top_table_cell.png"];
        }
        if(indexPath.row == 1){
            cell.textLabel.text = @"Contact The Developers";
            background = [UIImage imageNamed:@"bottom_table_cell.png"];
            selected_background = [UIImage imageNamed:@"bottom_table_cell.png"];
        }
    }
    
    // Set the images.
    ((UIImageView *)cell.backgroundView).image = background;
    ((UIImageView *)cell.selectedBackgroundView).image = selected_background;    
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

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

#pragma mark - MFMailComposeViewController Delegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}


@end
