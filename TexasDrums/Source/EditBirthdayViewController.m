//
//  EditBirthdayViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "EditBirthdayViewController.h"

@implementation EditBirthdayViewController

@synthesize picker, birthdayLabel, submitButton, received_data, updatedBirthday, status;

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

- (void)viewWillAppear:(BOOL)animated {
    [[GANTracker sharedTracker] trackPageview:@"Edit Birthday (EditBirthdayView)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self parseDatabaseString];
    [self setTitle:@"Edit Birthday"];
    [picker addTarget:self action:@selector(updateLabel:) forControlEvents:UIControlEventValueChanged];
    self.status.alpha = 0.0f;
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"MMddyyyy"];

    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDate *current_date = [dateFormatter dateFromString:_Profile.birthday];
    NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
    [comps setYear:30];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:current_date options:0];
    [comps setYear:-70];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:current_date options:0];
    
    [picker setMaximumDate:maxDate];
    [picker setDate:current_date];
    [picker setMinimumDate:minDate];
    
    self.birthdayLabel.text = [self parseDatabaseString];
}

- (void)startConnection {
    
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&username=%@&password=%@&birthday=%@", TEXAS_DRUMS_API_EDIT_PROFILE, TEXAS_DRUMS_API_KEY, _Profile.username, _Profile.password, updatedBirthday];
    TDLog(@"%@", API_Call);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLConnection *urlconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if(urlconnection) {
        received_data = [[NSMutableData data] retain];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)submitButtonPressed:(id)sender {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int year = [[calendar components:NSYearCalendarUnit fromDate:picker.date] year];
    int month = [[calendar components:NSMonthCalendarUnit fromDate:picker.date] month];
    int day = [[calendar components:NSDayCalendarUnit fromDate:picker.date] day];
    TDLog(@"%d %d %d", month, day, year);
    
    NSString *month_str = [NSString stringWithFormat:@"%d", month];
    NSString *day_str = [NSString stringWithFormat:@"%d", day];
    
    if(month < 10){
        month_str = [NSString stringWithFormat:@"0%d", month];
    }
    if(day < 10){
        day_str = [NSString stringWithFormat:@"0%d", day];
    }
    
    NSString *date = [NSString stringWithFormat:@"%@%@%d", month_str, day_str, year];
    if([date isEqualToString:_Profile.birthday]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"Your birthday didn't change. Please choose your correct birthday or press the 'Back' button to cancel."
                                                       delegate:self 
                                              cancelButtonTitle:@"Okay" 
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return;
    }

    self.updatedBirthday = date;
    TDLog(@"%@", date);
    [self startConnection];
    
}

- (NSString *)parseDatabaseString {
    NSString *month = [_Profile.birthday substringWithRange:NSMakeRange(0, 2)];
    NSString *day   = [_Profile.birthday substringWithRange:NSMakeRange(2, 2)];
    NSString *year  = [_Profile.birthday substringWithRange:NSMakeRange(4, 4)];
    
    NSString *result = [NSString stringWithFormat:@"%@ %@, %@", [self convertIntToMonth:[month intValue]], day, year];
    
    return result;
}

- (NSString *)convertIntToMonth:(int)month {
    switch (month) {
        case 1:
            return @"January";
            break;
        case 2:
            return @"February";
            break;
        case 3:
            return @"March";
            break;
        case 4:
            return @"April";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"June";
            break;
        case 7:
            return @"July";
            break;
        case 8:
            return @"August";
            break;
        case 9:
            return @"September";
            break;
        case 10:
            return @"October";
            break;
        case 11:
            return @"November";
            break;
        case 12:
            return @"December";
            break;
        default:
            return @"";
            break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)updateLabel:(id)sender {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int year = [[calendar components:NSYearCalendarUnit fromDate:picker.date] year];
    int month = [[calendar components:NSMonthCalendarUnit fromDate:picker.date] month];
    int day = [[calendar components:NSDayCalendarUnit fromDate:picker.date] day];
    TDLog(@"%d %d %d", month, day, year);
    
    self.birthdayLabel.text = [NSString stringWithFormat:@"%@ %d, %d", [self convertIntToMonth:month], day, year];
}   

- (void)displayText:(NSString *)text {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.status.text = text;
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.50];
    self.status.alpha = 1.0;
	[UIView commitAnimations];
    [pool release];
}

- (void)removeError {
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.5];
    self.status.alpha = 0.0;
	[UIView commitAnimations];
}

- (void)sendToProfileView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    [received_data setLength:0];
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
    
    [self performSelectorOnMainThread:@selector(showRefreshButton) withObject:nil waitUntilDone:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    //set _Profile birthday and set defaults in order to keep internal data in sync per startups
    _Profile.birthday = updatedBirthday;
    
    //inform user of successful update and pop screen
    [self performSelectorOnMainThread:@selector(displayText:) withObject:@"Your birthday has been updated." waitUntilDone:YES];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendToProfileView) userInfo:nil repeats:NO];
    
    TDLog(@"Succeeded! Received %d bytes of data", [received_data length]);
    
    // release the connection, and the data object
    [connection release];
    [received_data release];
}

@end
