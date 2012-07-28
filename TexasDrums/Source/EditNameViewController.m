//
//  EditNameViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "EditNameViewController.h"
#import "TexasDrumsGetEditProfile.h"
#import "CJSONDeserializer.h"

@implementation EditNameViewController

@synthesize firstname, lastname, submit, status;

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
    [[GANTracker sharedTracker] trackPageview:@"Edit Name (EditNameView)" withError:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Edit Name"];
    
    // Set properties.
    self.status.alpha = 0.0f;
    self.firstname.delegate = self;
    self.lastname.delegate = self;
    self.firstname.text = _Profile.firstname;
    self.lastname.text = _Profile.lastname;
    self.firstname.font = [UIFont TexasDrumsFontOfSize:14];
    self.lastname.font = [UIFont TexasDrumsFontOfSize:14];
    self.firstname.textColor = [UIColor TexasDrumsGrayColor];
    self.lastname.textColor = [UIColor TexasDrumsGrayColor];
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

- (void)removeKeyboard {
    [self.firstname resignFirstResponder];
    [self.lastname resignFirstResponder];
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
                                                                             withFirstName:firstname.text
                                                                               andLastName:lastname.text
                                                                        andUpdatedPassword:nil
                                                                                  andPhone:nil
                                                                               andBirthday:nil
                                                                                  andEmail:nil];
        get.delegate = self;
        [get startRequest];
    }
}

- (BOOL)checkConstraints {
    if(firstname.text.length == 0 || lastname.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:@"Please input your first and last name and try again."
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    else if([firstname.text isEqualToString:_Profile.firstname] && [lastname.text isEqualToString:_Profile.lastname]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:@"You didn't change anything! Please edit your name and press submit when you are done."
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
            if([[results objectForKey:@"status"] isEqualToString:_200OK]) {
                TDLog(@"Profile updated.");
                _Profile.firstname = firstname.text;
                _Profile.lastname = lastname.text;
                
                [self performSelectorOnMainThread:@selector(displayText:) withObject:@"Your name has been updated." waitUntilDone:YES];
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
