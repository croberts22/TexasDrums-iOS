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

@implementation ProfileViewController

@synthesize profileTable;

#pragma mark - Memory Management

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
    
    // Google Analytics
    [[GANTracker sharedTracker] trackPageview:@"Profile (ProfileView)" withError:nil];
    
    [self.profileTable reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Profile"];
    
    // Set properties.
    self.profileTable.backgroundColor = [UIColor clearColor];
    self.profileTable.separatorColor = [UIColor clearColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI Methods

- (void)setTitle:(NSString *)title
{
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ProfileCell = @"Profile";
    static NSString *Status = @"Status";
    
    UITableViewCell *cell;
    
    UIImage *background;
    UIImage *selected_background;
    
    if(indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:Status];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Status] autorelease];
            
            // UITableViewCell Properties
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            
            cell.textLabel.font = [UIFont TexasDrumsFontOfSize:12];
            cell.textLabel.textColor = [UIColor TexasDrumsOrangeColor];
            
            // Since a cell's background views are not compatible with UIImageView,
            // set them both as UIImageView.
            cell.backgroundView = [[[UIImageView alloc] init] autorelease];
            cell.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];
        }
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:ProfileCell];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ProfileCell] autorelease];
                        
            //UITableViewCell properties
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            
            cell.textLabel.font = [UIFont TexasDrumsFontOfSize:12];
            cell.textLabel.textColor = [UIColor TexasDrumsOrangeColor];
            cell.detailTextLabel.font = [UIFont TexasDrumsFontOfSize:16];
            cell.detailTextLabel.textColor = [UIColor TexasDrumsGrayColor];
            
            cell.backgroundView = [[[UIImageView alloc] init] autorelease];
            cell.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];
            
            background = [UIImage imageNamed:@"table_cell.png"];
            selected_background = [UIImage imageNamed:@"table_cell.png"];
        }
    }
    
    background = [UIImage imageNamed:@"table_cell.png"];
    selected_background = [UIImage imageNamed:@"table_cell.png"];
    
    if(indexPath.section == 0){
        switch(indexPath.row){
            case 0:
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", [UserProfile sharedInstance].firstname, [UserProfile sharedInstance].lastname];
                cell.textLabel.text = @"Name";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                background = [UIImage imageNamed:@"top_table_cell.png"];
                selected_background = [UIImage imageNamed:@"top_table_cell.png"];
                break;
            case 1:
                cell.detailTextLabel.text = [UserProfile sharedInstance].username;
                cell.textLabel.text = @"Username";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 2:
                cell.detailTextLabel.text = @"tap to change";
                cell.textLabel.text = @"Password";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;                
                cell.detailTextLabel.font = [UIFont TexasDrumsItalicFontOfSize:12];
                cell.detailTextLabel.textColor = [UIColor whiteColor];
                break;
            case 3:
                cell.detailTextLabel.text = [UserProfile sharedInstance].section;
                cell.textLabel.text = @"Section";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 4:
                cell.detailTextLabel.text = [UserProfile sharedInstance].years;
                cell.textLabel.text = @"Years";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 5:
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Member", [UserProfile sharedInstance].status];
                cell.textLabel.text = @"Status";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                background = [UIImage imageNamed:@"bottom_table_cell.png"];
                selected_background = [UIImage imageNamed:@"bottom_table_cell.png"];
                break;
            default:
                break;
        }
    }
    else if(indexPath.section == 1){
        switch(indexPath.row){
            case 0:
                cell.detailTextLabel.text = [NSString parsePhoneNumber:[UserProfile sharedInstance].phonenumber];
                cell.textLabel.text = @"Phone";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                background = [UIImage imageNamed:@"top_table_cell.png"];
                selected_background = [UIImage imageNamed:@"top_table_cell.png"];
                break; 
            case 1:
                cell.detailTextLabel.text = [UserProfile sharedInstance].email;
                cell.textLabel.text = @"Email";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 2:
                cell.detailTextLabel.text = [NSString parseBirthday:[UserProfile sharedInstance].birthday];
                cell.textLabel.text = @"Birthday";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                background = [UIImage imageNamed:@"bottom_table_cell.png"];
                selected_background = [UIImage imageNamed:@"bottom_table_cell.png"];
                break;
            default:
                break;
        }
    }
    else{
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont TexasDrumsBoldFontOfSize:16];
        
        if([UserProfile sharedInstance].paid){
            cell.textLabel.text = @"You have paid. Thank you!";
        }
        else{
            cell.textLabel.text = @"You have not paid $3 yet.";
        }
        
        background = nil;
        selected_background = nil;
    }
    
    // Set the images.
    ((UIImageView *)cell.backgroundView).image = background;
    ((UIImageView *)cell.selectedBackgroundView).image = selected_background;
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.profileTable deselectRowAtIndexPath:indexPath animated:YES];

    if(indexPath.section == 0){
        if(indexPath.row == 0){
            EditNameViewController *ENVC = [[[EditNameViewController alloc] initWithNibName:@"EditNameView" bundle:[NSBundle mainBundle]] autorelease];
            [self.navigationController pushViewController:ENVC animated:YES];
        }
        else if(indexPath.row == 2){
            EditPasswordViewController *EPVC = [[[EditPasswordViewController alloc] initWithNibName:@"EditPasswordView" bundle:[NSBundle mainBundle]] autorelease];
            [self.navigationController pushViewController:EPVC animated:YES];
        }
    }
    else if(indexPath.section == 1){
        if(indexPath.row == 0){
            EditPhoneViewController *EPVC = [[[EditPhoneViewController alloc] initWithNibName:@"EditPhoneView" bundle:[NSBundle mainBundle]] autorelease];
            [self.navigationController pushViewController:EPVC animated:YES];
        }
        else if(indexPath.row == 1){
            EditEmailViewController *EEVC = [[[EditEmailViewController alloc] initWithNibName:@"EditEmailView" bundle:[NSBundle mainBundle]] autorelease];
            [self.navigationController pushViewController:EEVC animated:YES];
        }
        else{
            EditBirthdayViewController *EBVC = [[[EditBirthdayViewController alloc] initWithNibName:@"EditBirthdayView" bundle:[NSBundle mainBundle]] autorelease];
            [self.navigationController pushViewController:EBVC animated:YES];
        }
    }
}

@end
