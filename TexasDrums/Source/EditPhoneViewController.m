//
//  EditPhoneViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "EditPhoneViewController.h"
#import "TexasDrumsGetEditProfile.h"
#import "CJSONDeserializer.h"

@implementation EditPhoneViewController

@synthesize phone, status, submit, background_button;

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

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    // Google Analytics
    [[GANTracker sharedTracker] trackPageview:@"Edit Phone (EditPhoneView)" withError:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Edit Phone Number"];
    
    // Set properties.
    self.status.alpha = 0.0f;
    self.phone.delegate = self;
    self.phone.text = _Profile.phonenumber;
    self.phone.textColor = [UIColor TexasDrumsGrayColor];
    self.phone.font = [UIFont TexasDrumsFontOfSize:14];
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

- (void)dismissWithSuccess {
    [SVProgressHUD dismiss];
}

- (void)dismissWithError {
    [SVProgressHUD showErrorWithStatus:@"Unable to save."];
}

- (IBAction)submitButtonPressed:(id)sender {
    [self connect];
}

- (IBAction)backgroundButtonPressed:(id)sender {
    [self removeKeyboard];
}

- (void)removeKeyboard {
    [self.phone resignFirstResponder];
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

#pragma mark - Data Methods

- (void)connect {
    
    [self removeKeyboard];
    
    BOOL passedConstraints = [self checkConstraints];
    
    if(passedConstraints) {
        [SVProgressHUD showWithStatus:@"Updating..."];
        TexasDrumsGetEditProfile *get = [[TexasDrumsGetEditProfile alloc] initWithUsername:_Profile.username
                                                                               andPassword:_Profile.password
                                                                             withFirstName:nil
                                                                               andLastName:nil
                                                                        andUpdatedPassword:nil
                                                                                  andPhone:self.phone.text
                                                                               andBirthday:nil
                                                                                  andEmail:nil];
        get.delegate = self;
        [get startRequest];
    }
    

}

- (BOOL)checkConstraints {
    if([self.phone.text isEqualToString:_Profile.phonenumber]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your phone number didn't change. Please type in a new phone number."
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    else if([self.phone.text length] != 10){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your phone number is invalid. Please type in a new phone number."
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    else return YES;
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [phone resignFirstResponder];
    [self connect];
    
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
            if([[results objectForKey:@"status"] isEqualToString:_200OK]) {
                TDLog(@"Profile updated.");
                _Profile.phonenumber = self.phone.text;
                
                [self performSelectorOnMainThread:@selector(displayText:) withObject:@"Your phone number has been updated." waitUntilDone:YES];
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
