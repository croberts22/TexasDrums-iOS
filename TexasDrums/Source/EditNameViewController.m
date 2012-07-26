//
//  EditNameViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "EditNameViewController.h"
#import "TexasDrumsGetEditProfile.h"
#import "GANTracker.h"
#import "SVProgressHUD.h"
#import "UIColor+TexasDrums.h"
#import "UIFont+TexasDrums.h"
#import "CJSONDeserializer.h"

@implementation EditNameViewController

#define _403 (@"403 ERROR: No input given")

@synthesize firstname, lastname, submit, status;

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

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    // Google Analytics
    [[GANTracker sharedTracker] trackPageview:@"Edit Name (EditNameView)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Edit Name"];
    
    // Set properties.
    status.alpha = 0.0f;
    firstname.delegate = self;
    lastname.delegate = self;
    firstname.text = _Profile.firstname;
    lastname.text = _Profile.lastname;
    firstname.font = [UIFont TexasDrumsFontOfSize:14];
    lastname.font = [UIFont TexasDrumsFontOfSize:14];
    firstname.textColor = [UIColor lightGrayColor];
    lastname.textColor = [UIColor lightGrayColor];
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

- (void)dismissWithSuccess {
    [SVProgressHUD dismiss];
}

- (void)dismissWithError {
    [SVProgressHUD showErrorWithStatus:@"Unable to save."];
}

- (IBAction)submitButtonPressed:(id)sender {
    [self connect];
}

- (void)removeKeyboard {
    [firstname resignFirstResponder];
    [lastname resignFirstResponder];
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

#pragma mark - Data Methods

- (void)connect {
    
    [self removeKeyboard];
    
    if([firstname.text isEqualToString:@""] || [lastname.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:@"Please input your first and last name and then press submit."
                                                       delegate:self 
                                              cancelButtonTitle:@"Okay" 
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    else if([firstname.text isEqualToString:_Profile.firstname] && [lastname.text isEqualToString:_Profile.lastname]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:@"You didn't change anything! Please edit your name and press submit when you are done."
                                                       delegate:self 
                                              cancelButtonTitle:@"Okay" 
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }

    
    [SVProgressHUD showWithStatus:@"Updating..."];
    TexasDrumsGetEditProfile *get = [[TexasDrumsGetEditProfile alloc] initWithUsername:_Profile.username 
                                                                           andPassword:_Profile.password 
                                                                         withFirstName:firstname.text 
                                                                           andLastName:lastname.text
                                                                    andUpdatedPassword:nil 
                                                                              andPhone:nil 
                                                                           andBirthday:nil
                                                                              andEmail:nil];
    get.delegate = self;
    [get startRequest];
}


#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == firstname){
        [lastname becomeFirstResponder];
    }
    else { 
        [textField resignFirstResponder];
        [self submitButtonPressed:nil];
    }
    
    return YES;
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
            if(![[results objectForKey:@"status"] isEqualToString:_200OK]) {
                TDLog(@"Unable to update profile. Request returned: %@", [results objectForKey:@"status"]);
                [self dismissWithSuccess];
                return;
            }
        }
        
        TDLog(@"Profile updated.");
        _Profile.firstname = firstname.text;
        _Profile.lastname = lastname.text;
        
        [self performSelectorOnMainThread:@selector(displayText:) withObject:@"Your name has been updated." waitUntilDone:YES];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendToProfileView) userInfo:nil repeats:NO];
        [self dismissWithSuccess];
    }
    else {
        TDLog(@"Could not update profile..");
        [self dismissWithError];
    }
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    TDLog(@"Request error: %@", error);
    
    // Show refresh button and error message.
    [self dismissWithError];
}

@end
