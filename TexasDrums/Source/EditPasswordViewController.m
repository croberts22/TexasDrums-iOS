//
//  EditPasswordViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "EditPasswordViewController.h"
#import "TexasDrumsGetEditProfile.h"
#import "CJSONDeserializer.H"

@implementation EditPasswordViewController

@synthesize original_password, a_new_password, a_new_password_again, length_constraint, alpha_constraint, numerical_constraint, background_button, status;

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
    [[GANTracker sharedTracker] trackPageview:@"Edit Password (EditPasswordView)" withError:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Edit Password"];
    
    // Set properties.
    self.original_password.delegate = self;
    self.a_new_password.delegate = self;
    self.a_new_password_again.delegate = self;
    
    self.length_constraint.textColor = [UIColor TexasDrumsGrayColor];
    self.alpha_constraint.textColor = [UIColor TexasDrumsGrayColor];
    self.numerical_constraint.textColor = [UIColor TexasDrumsGrayColor];
    
    self.original_password.font = [UIFont TexasDrumsFontOfSize:14];
    self.a_new_password.font = [UIFont TexasDrumsFontOfSize:14];
    self.a_new_password_again.font = [UIFont TexasDrumsFontOfSize:14];
    
    self.original_password.textColor = [UIColor TexasDrumsGrayColor];
    self.a_new_password.textColor = [UIColor TexasDrumsGrayColor];
    self.a_new_password_again.textColor = [UIColor TexasDrumsGrayColor];
    
    self.status.alpha = 0.0f;
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

- (IBAction)backgroundButtonPressed:(id)sender {
    [original_password resignFirstResponder];
    [a_new_password resignFirstResponder];
    [a_new_password_again resignFirstResponder];
}

- (void)removeKeyboard {
    [original_password resignFirstResponder];
    [a_new_password resignFirstResponder];
    [a_new_password_again resignFirstResponder];
    self.length_constraint.textColor = [UIColor TexasDrumsGrayColor];
    self.alpha_constraint.textColor = [UIColor TexasDrumsGrayColor];
    self.numerical_constraint.textColor = [UIColor TexasDrumsGrayColor];
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
                                                                        andUpdatedPassword:self.a_new_password.text
                                                                                  andPhone:nil
                                                                               andBirthday:nil
                                                                                  andEmail:nil];
        get.delegate = self;
        [get startRequest];
    }
}

- (BOOL)checkConstraints {
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"Okay"
                                           otherButtonTitles:nil, nil] autorelease];
    
    // Check for empty fields
    if(original_password.text.length == 0 || a_new_password.text.length == 0 || a_new_password_again.text.length == 0){
        alert.message = @"Please fill out all fields.";
        [alert show];
        return NO;
    }
    
    // Check if the original password matches with what we have stored.
    if([_Profile.password isEqualToString:original_password.text]){
        
        // If they match, check if the two new password fields match.
        if([a_new_password.text isEqualToString:a_new_password_again.text]){
            
            // If those match, then check if the password typed in is the same as the old one.
            if([original_password.text isEqualToString:a_new_password.text]){
                alert.message = @"Your original password and your new password are the same. Please enter a different password.";
                [alert show];
                return NO;
            }
            
            // Check if the new password fits the desired password boundaries (8-16 characters)
            if([a_new_password.text length] >= 8 && [a_new_password.text length] <= 16){
                
                // Remove alphabetical characters.
                // We do this check to assert that the password is not wholly alphabetical, and contains at least one
                // numerical character.
                NSString *checker = [a_new_password.text stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
                
                // If they don't match, then try the same comparison with the numerical characters.
                if([a_new_password.text length] != [checker length]){
                    
                    checker = [a_new_password.text stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
                    
                    // If this comparison is not equal, then we know that the password:
                    // 1) Has 8-16 characters,
                    // 2) Has at least one alphabetical character, and
                    // 3) Has at least one numerical character.
                    // We can now successfully update the password.
                    if([a_new_password.text length] != [checker length]){
                        return YES;
                    }
                    else{
                        // Numerical constraint was not met.
                        alert.message = @"Your new password must contain at least one numerical character. Please try again.";
                        [alert show];
                        self.numerical_constraint.textColor = [UIColor redColor];
                        return NO;
                    }
                }
                else{
                    // Alphabetical constraint was not met.
                    alert.message = @"Your new password must contain at least one alphabetic character. Please try again.";
                    [alert show];
                    self.alpha_constraint.textColor = [UIColor redColor];
                    return NO;
                }
            }
            else{
                // Character length constraint was not met.
                alert.message = @"Your new password must be between 8-16 characters. Please try again.";
                [alert show];
                self.length_constraint.textColor = [UIColor redColor];
                return NO;
            }
        }
        else{
            // New password fields do not match.
            alert.message = @"Your new password entries are not the same.  Please try again.";
            [alert show];
            return NO;
        }
    }
    else{
        // Original password field does not match what we have stored currently.
        alert.message = @"Your old password does not match your current password. Please try again.";
        [alert show];
        return NO;
    }
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == original_password){
        [a_new_password becomeFirstResponder];
    }
    else if(textField == a_new_password){
        [a_new_password_again becomeFirstResponder];
    }
    else{
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
                _Profile.password = a_new_password.text;
                
                [self performSelectorOnMainThread:@selector(displayText:) withObject:@"Your password has been updated." waitUntilDone:YES];
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
