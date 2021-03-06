//
//  EditBirthdayViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "EditBirthdayViewController.h"
#import "TexasDrumsGetEditProfile.h"
#import "CJSONDeserializer.h"

@implementation EditBirthdayViewController

@synthesize picker, birthdayLabel, submitButton, updatedBirthday, status;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [picker release], picker = nil;
    [birthdayLabel release], birthdayLabel = nil;
    [submitButton release], submitButton = nil;
    [updatedBirthday release], updatedBirthday = nil;
    [status release], status = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setTitle:@"Edit Birthday"];
    
    // When the picker changes value, update the label.
    [self.picker addTarget:self action:@selector(updateLabel:) forControlEvents:UIControlEventValueChanged];
    
    NSString *parseBirthday = [NSString parseBirthday:[UserProfile sharedInstance].birthday];
    if([parseBirthday isEqualToString:@"n/a"]){
        self.picker.date = [NSDate date];
    }
    else {
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"MMddyyyy"];
        NSDate *current_date = [dateFormatter dateFromString:[UserProfile sharedInstance].birthday];
        
        // Set properties.
        self.status.alpha = 0.0f;
        self.picker.date = current_date;
        
        self.birthdayLabel.text = [self parseDatabaseString];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI Methods

- (void)dismissWithSuccess {
    [SVProgressHUD dismiss];
}

- (void)dismissWithError {
    [SVProgressHUD showErrorWithStatus:@"Unable to save."];
}

- (IBAction)submitButtonPressed:(id)sender {
    [self connect];
}

- (void)displayText:(NSString *)text {
    self.status.text = text;
    [UIView animateWithDuration:.5f animations:^{
        self.status.alpha = 1.0;
    }];
}

- (void)removeError {
    [UIView animateWithDuration:.5f animations:^{
        self.status.alpha = 0.0;
    }];
}

- (void)sendToProfileView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateLabel:(id)sender {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int year = [[calendar components:NSYearCalendarUnit fromDate:picker.date] year];
    int month = [[calendar components:NSMonthCalendarUnit fromDate:picker.date] month];
    int day = [[calendar components:NSDayCalendarUnit fromDate:picker.date] day];
    
    self.birthdayLabel.text = [NSString stringWithFormat:@"%@ %d, %d", [self convertIntToMonth:month], day, year];
}

#pragma mark - Data Methods

- (void)connect {
    
    self.updatedBirthday = [self prepareDateString];
    
    BOOL passedConstraints = [self checkConstraints];
    
    if(passedConstraints) {
        [SVProgressHUD showWithStatus:@"Updating..."];
        TexasDrumsGetEditProfile *get = [[TexasDrumsGetEditProfile alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                               andPassword:[UserProfile sharedInstance].hash
                                                                             withFirstName:nil
                                                                               andLastName:nil
                                                                        andUpdatedPassword:nil
                                                                                  andPhone:nil
                                                                               andBirthday:self.updatedBirthday
                                                                                  andEmail:nil];
        get.delegate = self;
        [get startRequest];
    }
}

- (BOOL)checkConstraints {
    if([self.updatedBirthday isEqualToString:[UserProfile sharedInstance].birthday]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your birthday didn't change. Please choose your correct birthday or tap the 'Back' button to cancel."
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return NO;
    }
    else return YES;
}

- (NSString *)parseDatabaseString {
    NSString *birthday = [UserProfile sharedInstance].birthday;
    
    NSString *month = [birthday substringWithRange:NSMakeRange(0, 2)];
    NSString *day   = [birthday substringWithRange:NSMakeRange(2, 2)];
    NSString *year  = [birthday substringWithRange:NSMakeRange(4, 4)];
    
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

- (NSString *)prepareDateString {
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
    
   return [NSString stringWithFormat:@"%@%@%d", month_str, day_str, year];
}

#pragma mark - TexasDrumsRequestDelegate Methods

- (void)request:(TexasDrumsRequest *)request receivedData:(id)data {
    
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:data error:&error];
    
    if([results count] > 0){
        // Check if the response is just a dictionary value of one.
        // This implies that the key value pair follows the format:
        // status -> 'message'
        // We use respondsToSelector since the API returns a dictionary
        // of length one for any status messages, but an array of
        // dictionary responses for valid data.
        // CJSONDeserializer interprets actual data as NSArrays.
        if([results respondsToSelector:@selector(objectForKey:)] ){
            if([[results objectForKey:@"status"] isEqualToString:_200_OK]) {
                TDLog(@"Profile updated.");
                [UserProfile sharedInstance].birthday = self.updatedBirthday;
                
                [self performSelectorOnMainThread:@selector(displayText:) withObject:@"Your birthday has been updated." waitUntilDone:YES];
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendToProfileView) userInfo:nil repeats:NO];
                [self dismissWithSuccess];
            }
            else {
                TDLog(@"Unable to update profile. Request returned: %@", [results objectForKey:@"status"]);
                [self dismissWithError];
                return;
            }
        }
    }
    else {
        TDLog(@"Could not update profile.");
        [self dismissWithError];
    }
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    TDLog(@"Request error: %@", error);
    
    // Show refresh button and error message.
    [self dismissWithError];
}

@end
