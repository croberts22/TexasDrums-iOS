//
//  ProfileViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 8/9/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "ProfileViewController.h"
#import "EditNameViewController.h"
#import "EditPasswordViewController.h"
#import "EditPhoneViewController.h"
#import "EditBirthdayViewController.h"
#import "EditEmailViewController.h"
#import "GANTracker.h"

@implementation ProfileViewController

@synthesize profileTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [profileTable release];
    [super dealloc];
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [[GANTracker sharedTracker] trackPageview:@"Profile (ProfileView)" withError:nil];
    [self.profileTable reloadData];
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Profile"];
    self.profileTable.backgroundColor = [UIColor clearColor];
    self.profileTable.separatorColor = [UIColor clearColor];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 6;
    }
    else if(section == 1){
        return 3;
    }
    else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ProfileCell = @"Profile";
    static NSString *Status = @"Status";
    
    UITableViewCell *cell;
    if(indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:Status];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Status] autorelease];
        }
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:ProfileCell];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ProfileCell] autorelease];
        }
    }

    
    // Configure the cell...
    cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:12];
    cell.textLabel.textColor = [UIColor orangeColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Georgia" size:16];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    //UITableViewCell properties
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    if(indexPath.section == 0){
        switch(indexPath.row){
            case 0:
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", _Profile.firstname, _Profile.lastname];
                cell.textLabel.text = @"Name";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_table_cell.png"]] autorelease];
                ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"top_table_cell.png"];
                cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_table_cell.png"]] autorelease];
                ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"top_table_cell.png"];
                break;
            case 1:
                cell.detailTextLabel.text = _Profile.username;
                cell.textLabel.text = @"Username";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell.png"]] autorelease];
                ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"table_cell.png"];
                cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell.png"]] autorelease];
                ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"table_cell.png"];
                break;
            case 2:
                cell.detailTextLabel.text = @"tap to change";
                cell.detailTextLabel.font = [UIFont fontWithName:@"Georgia-Italic" size:12];
                cell.detailTextLabel.textColor = [UIColor whiteColor];
                cell.textLabel.text = @"Password";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell.png"]] autorelease];
                ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"table_cell.png"];
                cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell.png"]] autorelease];
                ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"table_cell.png"];
                break;
            case 3:
                cell.detailTextLabel.text = _Profile.section;
                cell.textLabel.text = @"Section";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell.png"]] autorelease];
                ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"table_cell.png"];
                cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell.png"]] autorelease];
                ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"table_cell.png"];
                break;
            case 4:
                cell.detailTextLabel.text = _Profile.years;
                cell.textLabel.text = @"Years";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell.png"]] autorelease];
                ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"table_cell.png"];
                cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell.png"]] autorelease];
                ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"table_cell.png"];
                break;
            case 5:
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Member", _Profile.status];
                cell.textLabel.text = @"Status";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_table_cell.png"]] autorelease];
                ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
                cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_table_cell.png"]] autorelease];
                ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
                break;
            default:
                break;
        }
    }
    else if(indexPath.section == 1){
        switch(indexPath.row){
            case 0:
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@-%@", 
                                             [_Profile.phonenumber substringWithRange:NSMakeRange(0, 3)],
                                             [_Profile.phonenumber substringWithRange:NSMakeRange(3, 3)],
                                             [_Profile.phonenumber substringWithRange:NSMakeRange(6, 4)]];
                cell.textLabel.text = @"Phone";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_table_cell.png"]] autorelease];
                ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"top_table_cell.png"];
                cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_table_cell.png"]] autorelease];
                ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"top_table_cell.png"];
                break; 
            case 1:
                cell.detailTextLabel.text = _Profile.email;
                cell.textLabel.text = @"Email";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell.png"]] autorelease];
                ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"table_cell.png"];
                cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell.png"]] autorelease];
                ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"table_cell.png"];
                break;
            case 2:
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@-%@", 
                                             [_Profile.birthday substringWithRange:NSMakeRange(0, 2)],
                                             [_Profile.birthday substringWithRange:NSMakeRange(2, 2)],
                                             [_Profile.birthday substringWithRange:NSMakeRange(4, 4)]];
                cell.textLabel.text = @"Birthday";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_table_cell.png"]] autorelease];
                ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
                cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_table_cell.png"]] autorelease];
                ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
                break;
            default:
                break;
        }
    }
    else{
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:16];
        if(_Profile.paid){
            cell.textLabel.text = @"You have paid. Thank you!";
        }
        else{
            cell.textLabel.text = @"You have not paid $3 yet.";
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.profileTable deselectRowAtIndexPath:indexPath animated:YES];
    //Name
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            EditNameViewController *ENVC = [[EditNameViewController alloc] initWithNibName:@"EditNameView" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:ENVC animated:YES];
            [ENVC release];
        }
        else if(indexPath.row == 2){
            EditPasswordViewController *EPVC = [[EditPasswordViewController alloc] initWithNibName:@"EditPasswordView" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:EPVC animated:YES];
            [EPVC release];
        }
    }
    else if(indexPath.section == 1){
        if(indexPath.row == 0){
            EditPhoneViewController *EPVC = [[EditPhoneViewController alloc] initWithNibName:@"EditPhoneView" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:EPVC animated:YES];
            [EPVC release];
        }
        else if(indexPath.row == 1){
            EditEmailViewController *EEVC = [[EditEmailViewController alloc] initWithNibName:@"EditEmailView" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:EEVC animated:YES];
            [EEVC release];
        }
        else{
            EditBirthdayViewController *EBVC = [[EditBirthdayViewController alloc] initWithNibName:@"EditBirthdayView" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:EBVC animated:YES];
            [EBVC release];
        }
    }
}

@end
