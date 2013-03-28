//
//  EditEmailViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "EditEmailViewController.h"
#import "TexasDrumsGetEditProfile.h"
#import "CJSONDeserializer.h"

@implementation EditEmailViewController

@synthesize email, submit, status, backgroundButton;

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

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Edit Email"];
    
    // Set properties.
    self.status.alpha = 0.0f;
    
    self.email.delegate = self;
    self.email.text = [UserProfile sharedInstance].email;
    self.email.textColor = [UIColor TexasDrumsGrayColor];
    self.email.font = [UIFont TexasDrumsFontOfSize:14];
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

- (IBAction)backgroundButtonPressed:(id)sender {
    [self removeKeyboard];
}

- (void)removeKeyboard {
    [self.email resignFirstResponder];
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
        TexasDrumsGetEditProfile *get = [[TexasDrumsGetEditProfile alloc] initWithUsername:[UserProfile sharedInstance].username
                                                                               andPassword:[UserProfile sharedInstance].hash
                                                                             withFirstName:nil
                                                                               andLastName:nil
                                                                        andUpdatedPassword:nil
                                                                                  andPhone:nil
                                                                               andBirthday:nil
                                                                                  andEmail:self.email.text];
        get.delegate = self;
        [get startRequest];

    }

}

- (BOOL)checkConstraints {
    if(self.email.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:@"Please input your email and then press submit."
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    else if([self.email.text isEqualToString:[UserProfile sharedInstance].email]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:@"You didn't change anything! Please edit your email and press submit when you are done."
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    else return YES;
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [email resignFirstResponder];
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
            if([[results objectForKey:@"status"] isEqualToString:_200_OK]) {
                TDLog(@"Profile updated.");
                [UserProfile sharedInstance].email = self.email.text;
                
                [self performSelectorOnMainThread:@selector(displayText:) withObject:@"Your email has been updated." waitUntilDone:YES];
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
