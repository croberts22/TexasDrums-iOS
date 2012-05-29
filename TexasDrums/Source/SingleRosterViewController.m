//
//  SingleRosterViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/28/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "SingleRosterViewController.h"
#import "RosterMember.h"
#import "SingleMemberView.h"
#import "TexasDrumsGroupedTableViewCell.h"
#import "GANTracker.h"

@implementation SingleRosterViewController

#define _HEADER_HEIGHT_ (50)

@synthesize snares, tenors, basses, cymbals, year, singleRosterTable;

- (void)dealloc
{
    [snares release];
    [tenors release];
    [basses release];
    [cymbals release];
    [year release];
    [singleRosterTable release];
    [super dealloc];
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:year];

    self.singleRosterTable.backgroundColor = [UIColor clearColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"%@ Roster (SingleRosterView)", year] withError:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
    return 4;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return _HEADER_HEIGHT_;
}

    //this overrides the titleForHeaderInSection method.
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    
    //create a new view of size _HEADER_HEIGHT_, and place a label inside.
    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, _HEADER_HEIGHT_)] autorelease];
    UILabel *headerTitle = [[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 30)] autorelease];
    headerTitle.textAlignment = UITextAlignmentLeft;
    headerTitle.textColor = [UIColor orangeColor];
    //headerTitle.shadowColor = [UIColor darkGrayColor];
    headerTitle.shadowOffset = CGSizeMake(0, 1);
    headerTitle.font = [UIFont fontWithName:@"Georgia-Bold" size:18];
    headerTitle.backgroundColor = [UIColor clearColor];
    [containerView addSubview:headerTitle];
    
    switch(section){
        case 0:
            headerTitle.text = @"Snares";
            break;
        case 1:
            headerTitle.text = @"Tenors";
            break;
        case 2:
            headerTitle.text = @"Basses";
            break;
        case 3:
            headerTitle.text = @"Cymbals";
            break;
        default:
            break;
    }
    
	return containerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section){
        case 0:
            return [snares count];
            break;
        case 1:
            return [tenors count];
            break;
        case 2:
            return [basses count];
            break;
        case 3:
            return [cymbals count];
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSArray *instrument = nil;
    
    TexasDrumsGroupedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TexasDrumsGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    switch(indexPath.section){
        case 0: //snares
            instrument = snares;
            break;
        case 1: //tenors
            instrument = tenors;
            break;
        case 2: //basses
            instrument = basses;
            break;
        case 3: //cymbals
            instrument = cymbals;
            break;
        default:
            break;
            
    }
    
    // Overriding TexasDrumsGroupedTableViewCell properties.
    cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:16];
    cell.textLabel.text = [[instrument objectAtIndex:indexPath.row] fullname];
    
    UIImage *background;
    UIImage *selected_background;
    
    // Since a cell's background views are not compatible with UIImageView,
    // set them both as UIImageView.
    cell.backgroundView = [[[UIImageView alloc] init] autorelease];
    cell.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];
    
    // Cell Background images.
    // TODO: Change the selected background image to something else.
    if(indexPath.row == 0){
        background = [UIImage imageNamed:@"top_table_cell.png"];
        selected_background = [UIImage imageNamed:@"top_table_cell.png"];
    }
    else if(indexPath.row == [instrument count]-1){
        background = [UIImage imageNamed:@"bottom_table_cell.png"];
        selected_background = [UIImage imageNamed:@"bottom_table_cell.png"];
    }
    else {
        background = [UIImage imageNamed:@"table_cell.png"];
        selected_background = [UIImage imageNamed:@"table_cell.png"];
    }
    
    // Set the images.
    ((UIImageView *)cell.backgroundView).image = background;
    ((UIImageView *)cell.selectedBackgroundView).image = selected_background;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.singleRosterTable deselectRowAtIndexPath:indexPath animated:YES];
    
    SingleMemberView *smv = [[SingleMemberView alloc] initWithNibName:@"SingleMemberView" bundle:[NSBundle mainBundle]];
    switch (indexPath.section){
        case 0: //snares
            smv.firstname = [[snares objectAtIndex:indexPath.row] firstname];
            smv.nickname = [[snares objectAtIndex:indexPath.row] nickname];
            smv.lastname = [[snares objectAtIndex:indexPath.row] lastname];
            smv.classification = [[snares objectAtIndex:indexPath.row] classification];
            smv.amajor = [[snares objectAtIndex:indexPath.row] amajor];
            smv.hometown = [[snares objectAtIndex:indexPath.row] hometown];
            smv.quote = [[snares objectAtIndex:indexPath.row] quote];
            smv.email = [[snares objectAtIndex:indexPath.row] email];
            smv.phonenumber = [[snares objectAtIndex:indexPath.row] phone];
            break;
        case 1: //tenors
            smv.firstname = [[tenors objectAtIndex:indexPath.row] firstname];
            smv.nickname = [[tenors objectAtIndex:indexPath.row] nickname];
            smv.lastname = [[tenors objectAtIndex:indexPath.row] lastname];
            smv.classification = [[tenors objectAtIndex:indexPath.row] classification];
            smv.amajor = [[tenors objectAtIndex:indexPath.row] amajor];
            smv.hometown = [[tenors objectAtIndex:indexPath.row] hometown];
            smv.quote = [[tenors objectAtIndex:indexPath.row] quote];
            smv.email = [[tenors objectAtIndex:indexPath.row] email];
            smv.phonenumber = [[tenors objectAtIndex:indexPath.row] phone];
            break;
        case 2: //basses
            smv.firstname = [[basses objectAtIndex:indexPath.row] firstname];
            smv.nickname = [[basses objectAtIndex:indexPath.row] nickname];
            smv.lastname = [[basses objectAtIndex:indexPath.row] lastname];            
            smv.classification = [[basses objectAtIndex:indexPath.row] classification];
            smv.amajor = [[basses objectAtIndex:indexPath.row] amajor];
            smv.hometown = [[basses objectAtIndex:indexPath.row] hometown];
            smv.quote = [[basses objectAtIndex:indexPath.row] quote];
            smv.email = [[basses objectAtIndex:indexPath.row] email];
            smv.phonenumber = [[basses objectAtIndex:indexPath.row] phone];
            break;
        case 3: //cymbals
            smv.firstname = [[cymbals objectAtIndex:indexPath.row] firstname];
            smv.nickname = [[cymbals objectAtIndex:indexPath.row] nickname];
            smv.lastname = [[cymbals objectAtIndex:indexPath.row] lastname];
            smv.classification = [[cymbals objectAtIndex:indexPath.row] classification];
            smv.amajor = [[cymbals objectAtIndex:indexPath.row] amajor];
            smv.hometown = [[cymbals objectAtIndex:indexPath.row] hometown];
            smv.quote = [[cymbals objectAtIndex:indexPath.row] quote];
            smv.email = [[cymbals objectAtIndex:indexPath.row] email];
            smv.phonenumber = [[cymbals objectAtIndex:indexPath.row] phone];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:smv animated:YES];
    [smv release];
}

@end
