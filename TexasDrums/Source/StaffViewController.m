//
//  StaffViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 1/13/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "StaffViewController.h"
#import "StaffMember.h"
#import "CJSONDeserializer.h"
#import "GANTracker.h"
#import "UIImageView+WebCache.h"
#import "TexasDrumsTableViewCell.h"
#import "StaffMemberViewController.h"

@implementation StaffViewController

//this will need to be changed. add 11-12 extension in the API for current_year.
#define DOMAIN_PATH (@"http://www.texasdrums.com/")

@synthesize staffTable, staff, indicator, status, received_data;

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

- (void)displayTable {
    float delay = 1.0f;
    [self.staffTable reloadData];
    [UIView beginAnimations:@"displayStaffTable" context:NULL];
    [UIView setAnimationDelay:delay];
    self.staffTable.alpha = 1.0f;
    self.indicator.alpha = 0.0f;
    self.status.alpha = 0.0f;
    [UIView commitAnimations];
    [self.indicator performSelector:@selector(stopAnimating) withObject:nil afterDelay:delay+.25];
}

- (void)viewWillAppear:(BOOL)animated {
    [[GANTracker sharedTracker] trackPageview:@"Staff (StaffView)" withError:nil];
    NSIndexPath *indexPath = [self.staffTable indexPathForSelectedRow];
    if(indexPath) {
        [self.staffTable deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Staff"];
    
    if(staff == nil){
        staff = [[NSMutableArray alloc] init];
    }
    //set table properties
    self.staffTable.backgroundColor = [UIColor clearColor];
    self.staffTable.separatorColor = [UIColor grayColor];
    self.staffTable.alpha = 0.0f;
    
    self.indicator.alpha = 1.0f;
    self.status.alpha = 1.0f;
    self.status.text = @"Loading...";
    
    [self fetchStaff];
}


- (void)fetchStaff {
    [self startConnection];
}

- (void)startConnection {
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@", TEXAS_DRUMS_API_STAFF, TEXAS_DRUMS_API_KEY];
    TDLog(@"%@", API_Call);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLConnection *urlconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if(urlconnection) {
        received_data = [[NSMutableData data] retain];
    }
}

- (void)parseStaffData:(NSDictionary *)results {
    for(NSDictionary *item in results){
        StaffMember *member = [[StaffMember alloc] init];
        member.first = [item objectForKey:@"firstname"];
        member.last = [item objectForKey:@"lastname"];
        member.fullname = [NSString stringWithFormat:@"%@ %@", member.first, member.last];
        member.instrument = [item objectForKey:@"section"];
        member.year = [item objectForKey:@"year"];
        member.bio = [item objectForKey:@"bio"];
        member.image_url = [item objectForKey:@"image"];
        member.email = [item objectForKey:@"email"];
        member.sortfield = [[item objectForKey:@"sortfield"] intValue];
        
        [staff addObject:member];
        
        [member release];
    }
    
    [self displayTable]; 
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [staff count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TexasDrumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[TexasDrumsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:18.0f];
    
    // Asynchronously fetch the Staff image; in the mean time, use a thumbnail        
    // until the image is fetched.
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DOMAIN_PATH, [[staff objectAtIndex:indexPath.row] image_url]]];
    
    [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Thumbnail.png"]];
    cell.textLabel.text = [[staff objectAtIndex:indexPath.row] fullname];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.text = [[staff objectAtIndex:indexPath.row] instrument];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StaffMemberViewController *SMVC = [[StaffMemberViewController alloc] init];
    SMVC.member = [staff objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:SMVC animated:YES];
    [SMVC release];
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    [received_data setLength:0];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to received_data.
    [received_data appendData:data];
}


- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    [received_data release];
    
    // inform the user
    TDLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" 
                                                    message:[error localizedDescription] 
                                                   delegate:self 
                                          cancelButtonTitle:@":( Okay" 
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
    self.status.text = @"Nothing was found. Please try again later.";
    [self.indicator stopAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:received_data error:&error];
    
    [self parseStaffData:results];
    
    TDLog(@"Succeeded! Received %d bytes of data.", [received_data length]);
    
    // release the connection, and the data object
    [connection release];
    [received_data release];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}



@end
