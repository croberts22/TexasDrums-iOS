//
//  MediaViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "MediaViewController.h"
#import "AudioViewController.h"
#import "VideoViewController.h"
#import "PictureViewController.h"
#import "GANTracker.h"


@implementation MediaViewController

@synthesize mediaOptions, mediaTable;

- (void)dealloc
{
    [mediaOptions release];
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
    
    [self setTitle:@"Media"];
    mediaOptions = [[NSArray alloc] initWithObjects:@"Audio", @"Video", nil];
    //mediaOptions = [[NSArray alloc] initWithObjects:@"Audio", @"Video", @"Pictures", nil];
    self.mediaTable.backgroundColor = [UIColor clearColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[GANTracker sharedTracker] trackPageview:@"Media (MediaView)" withError:nil];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [mediaOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    //set text to center, light gray with a clear background in the cell
    cell.textLabel.text = [mediaOptions objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:18];    
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.clipsToBounds = YES;
    
    //configure cell background images
    if(indexPath.row == 0){
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_table_cell.png"]] autorelease];
        ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"top_table_cell.png"];
    }
    if(indexPath.row == 1){
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_table_cell.png"]] autorelease];
        ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
        /*
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell.png"]] autorelease];
        ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"table_cell.png"];
         */
    }
/*
    if(indexPath.row == 2){
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_table_cell.png"]] autorelease];
        ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
    }
 */
    
    //configure cell selection background images here
    if(indexPath.row == 0){
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_table_cell.png"]] autorelease];
        ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"top_table_cell.png"];
    }
    if(indexPath.row == 1){
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_table_cell.png"]] autorelease];
        ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
        /*
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell.png"]] autorelease];
        ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"table_cell.png"];
         */
    }
    /*
    if(indexPath.row == 2){
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_table_cell.png"]] autorelease];
        ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"bottom_table_cell.png"];
    }
     */

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    [self.mediaTable deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0) {
        AudioViewController *AVC = [[[AudioViewController alloc] initWithNibName:@"AudioView" bundle:[NSBundle mainBundle]] autorelease];
        [self.navigationController pushViewController:AVC animated:YES];
    }
    else if(indexPath.row == 1) {
        VideoViewController *VVC = [[[VideoViewController alloc] initWithNibName:@"VideoView" bundle:[NSBundle mainBundle]] autorelease];
        [self.navigationController pushViewController:VVC animated:YES];
    }
    else if(indexPath.row == 2) {
        PictureViewController *PVC = [[[PictureViewController alloc] initWithNibName:@"PictureView" bundle:[NSBundle mainBundle]] autorelease];
        [self.navigationController pushViewController:PVC animated:YES];
    }
    else {
        return;
    }
}

@end
