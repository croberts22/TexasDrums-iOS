//
//  EditPasswordViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "EditPasswordViewController.h"
#import "GANTracker.h"

@implementation EditPasswordViewController

#define _403 (@"403 ERROR: No input given")

@synthesize original_password, a_new_password, a_new_password_again, length_constraint, alpha_constraint, numerical_constraint, background_button, status;

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
    [[GANTracker sharedTracker] trackPageview:@"Edit Password (EditPasswordView)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Edit Password"];
    original_password.delegate = self;
    a_new_password.delegate = self;
    a_new_password_again.delegate = self;
    
    //set original colors to gray
    self.length_constraint.textColor = [UIColor grayColor];
    self.alpha_constraint.textColor = [UIColor grayColor];
    self.numerical_constraint.textColor = [UIColor grayColor];
    
    //set font and colors
    self.original_password.font = [UIFont fontWithName:@"Georgia" size:14];
    self.a_new_password.font = [UIFont fontWithName:@"Georgia" size:14];
    self.a_new_password_again.font = [UIFont fontWithName:@"Georgia" size:14];
    
    self.original_password.textColor = [UIColor lightGrayColor];
    self.a_new_password.textColor = [UIColor lightGrayColor];
    self.a_new_password_again.textColor = [UIColor lightGrayColor];
    
    self.status.alpha = 0.0f;
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

/******
 ******/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == original_password){
        [a_new_password becomeFirstResponder];
    }
    else if(textField == a_new_password){
        [a_new_password_again becomeFirstResponder];
    }
    else{ //new_password_again is responder; submit
        [textField resignFirstResponder];
        [self submitButtonPressed:nil];
    }
    
    return YES;
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
    self.length_constraint.textColor = [UIColor grayColor];
    self.alpha_constraint.textColor = [UIColor grayColor];
    self.numerical_constraint.textColor = [UIColor grayColor];
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

- (IBAction)submitButtonPressed:(id)sender {
    //check if original password field is empty
    if(original_password.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"You did not enter your password. Please input your password and try again." 
                                                       delegate:self        
                                              cancelButtonTitle:@"Okay" 
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;        
    }
    //check if original passwords match
    if([_Profile.password isEqualToString:original_password.text]){
        //if they match, check new password and retyped password match
        if([a_new_password.text isEqualToString:a_new_password_again.text]){
            //check if the original and the new passwords match
            if([original_password.text isEqualToString:a_new_password.text]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                message:@"Your original password and your new password are the same. Please enter a different password." 
                                                               delegate:self        
                                                      cancelButtonTitle:@"Okay" 
                                                      otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                return;
            }
            //check for conditions
            //if between 8-16 chars
            if([a_new_password.text length] >= 8 && [a_new_password.text length] <= 16){
                //need to add additional condition here..
                //remove alpha characters. the lengths of the new password and the checker should not match.
                NSString *checker = [a_new_password.text stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
                //if lengths aren't same, check numerical
                if([a_new_password.text length] != [checker length]){
                    checker = [a_new_password.text stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
                    //if not the same length, then we know it contains
                    //at least one alpha and one numerical character.
                    if([a_new_password.text length] != [checker length]){
                        //success
                        [self updatePassword:a_new_password.text];
                    }
                    else{
                        //numerical constraint not met
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                        message:@"Your password must contain at least one numerical character. Please try again." 
                                                                       delegate:self        
                                                              cancelButtonTitle:@"Okay" 
                                                              otherButtonTitles:nil, nil];
                        [alert show];
                        [alert release];
                        numerical_constraint.textColor = [UIColor redColor];
                    }
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                    message:@"Your password must contain at least one alphabetic character. Please try again." 
                                                                   delegate:self        
                                                          cancelButtonTitle:@"Okay" 
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                    alpha_constraint.textColor = [UIColor redColor];
                }
            }
            else{
                //does not meet 8-16 character guideline
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                message:@"Your password must be between 8-16 characters. Please try again." 
                                                               delegate:self        
                                                      cancelButtonTitle:@"Okay" 
                                                      otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                //add color change to label here
                length_constraint.textColor = [UIColor redColor];
            }
        }
        else{
            //throw new passwords don't match error
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                            message:@"Your new password entries are not the same.  Please type them again." 
                                                           delegate:self        
                                                  cancelButtonTitle:@"Okay" 
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
    else{
        //throw original passwords don't match error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"Your password entry does not match your current password. Please type them again." 
                                                       delegate:self        
                                              cancelButtonTitle:@"Okay" 
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

- (void)sendToProfileView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updatePassword:(NSString *)password {
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&username=%@&password=%@&new_password=%@", TEXAS_DRUMS_API_EDIT_PROFILE, TEXAS_DRUMS_API_KEY, _Profile.username, _Profile.password, password];
    NSLog(@"%@", API_Call);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *get = [[[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding] autorelease];
    
    if([get isEqualToString:_200OK]){
        //set _Profile password and set defaults in order to keep internal data in sync per startups
        _Profile.password = password;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"login_password" forKey:password];
        
        //inform user of successful update and pop screen
        [self performSelectorOnMainThread:@selector(displayText:) withObject:@"Your password has been updated." waitUntilDone:YES];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendToProfileView) userInfo:nil repeats:NO];
    }
    else if([get isEqualToString:@""]){
        [self performSelectorOnMainThread:@selector(displayText:) withObject:@"Could not update password." waitUntilDone:YES];
    }

}

@end
