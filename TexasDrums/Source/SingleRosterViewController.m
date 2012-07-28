//
//  SingleRosterViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/28/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "SingleRosterViewController.h"
#import "Roster.h"
#import "RosterMember.h"
#import "SingleMemberView.h"
#import "TexasDrumsGroupedTableViewCell.h"

@implementation SingleRosterViewController

#define _HEADER_HEIGHT_ (50)

@synthesize roster, year, singleRosterTable;

- (void)dealloc
{
    [roster release];
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
        titleView.font = [UIFont TexasDrumsBoldFontOfSize:20];
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
    
    // Google Analytics
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section){
        case 0:
            return [[roster snares] count];
            break;
        case 1:
            return [[roster tenors] count];
            break;
        case 2:
            return [[roster basses] count];
            break;
        case 3:
            return [[roster cymbals] count];
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return _HEADER_HEIGHT_;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    
    // Create a custom header.
    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, _HEADER_HEIGHT_)] autorelease];
    UILabel *headerTitle = [[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 30)] autorelease];
    
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
    
    // Set header title properties.
    headerTitle.backgroundColor = [UIColor clearColor];
    headerTitle.textAlignment = UITextAlignmentLeft;
    headerTitle.textColor = [UIColor TexasDrumsOrangeColor];
    headerTitle.font = [UIFont TexasDrumsBoldFontOfSize:18];
    headerTitle.shadowOffset = CGSizeMake(0, 1);
    
    [containerView addSubview:headerTitle];
    
	return containerView;
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
        case 0: 
            instrument = [roster snares];
            break;
        case 1: 
            instrument = [roster tenors];
            break;
        case 2: 
            instrument = [roster basses];
            break;
        case 3: 
            instrument = [roster cymbals];
            break;
        default:
            break;
    }
    
    // Override TexasDrumsGroupedTableViewCell properties.
    cell.textLabel.font = [UIFont TexasDrumsFontOfSize:16];
    
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
    
    cell.textLabel.text = [[instrument objectAtIndex:indexPath.row] fullname];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // *** Consider moving this out and doing an animation in viewWillAppear when popping.
    [self.singleRosterTable deselectRowAtIndexPath:indexPath animated:YES];
    
    SingleMemberView *SMV = [[SingleMemberView alloc] initWithNibName:@"SingleMemberView" bundle:[NSBundle mainBundle]];
    
    switch (indexPath.section) {
        case 0:
            SMV.member = [roster.snares objectAtIndex:indexPath.row];
            break;
        case 1:
            SMV.member = [roster.tenors objectAtIndex:indexPath.row];
            break;
        case 2:
            SMV.member = [roster.basses objectAtIndex:indexPath.row];
            break;
        case 3:
            SMV.member = [roster.cymbals objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:SMV animated:YES];
    [SMV release];
}

@end
