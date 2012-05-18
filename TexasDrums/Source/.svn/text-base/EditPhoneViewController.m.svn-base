//
//  EditPhoneViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 University of Texas at Austin. All rights reserved.
//

#import "EditPhoneViewController.h"
#import "GANTracker.h"

@implementation EditPhoneViewController

#define _200OK (@"200 OK")
#define _403 (@"403 ERROR: No input given")

@synthesize phone, status, submit, background_button;

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
    [[GANTracker sharedTracker] trackPageview:@"Edit Phone (EditPhoneView)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Edit Phone Number"];
    status.alpha = 0.0f;
    phone.delegate = self;
    phone.text = _Profile.phonenumber;
    phone.textColor = [UIColor lightGrayColor];
    phone.font = [UIFont fontWithName:@"Georgia" size:14];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [phone resignFirstResponder];
    [self submitButtonPressed:nil];
    
    return YES;
}

- (IBAction)backgroundButtonPressed:(id)sender {
    [phone resignFirstResponder];
}

/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 
{
    NSLog(@"textField:|%@|", textField.text);
    NSLog(@"string:|%@|", string);
    
    NSString *result;
    
    if (![string isEqualToString:@""] && 
        (textField.text.length == 3 || textField.text.length == 6){
        
    }
    //if the string is empty, then we know we are subtracting
    if([string isEqualToString:@""]){
        result = [self subtractNumberFromGroup:textField.text];
    }
    //add number to group
    else{
        result = [self addNumber:string toGroup:textField.text];
    }
    
    textField.text = result;
    
    NSLog(@"new textField:|%@|", textField.text);
    
    return NO;
}
 */

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

- (IBAction)submitButtonPressed:(id)sender {
    if([phone.text isEqualToString:_Profile.phonenumber]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"Your phone number didn't change. Please type in a new phone number."
                                                       delegate:self 
                                              cancelButtonTitle:@"Okay" 
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if([phone.text length] != 10){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"Your phone number is invalid. Please type in a new phone number."
                                                       delegate:self 
                                              cancelButtonTitle:@"Okay" 
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if([phone.text length] == 10){
        [self updatePhone];
    }
}

- (void)sendToProfileView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updatePhone {
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&username=%@&password=%@&phone=%@", TEXAS_DRUMS_API_EDIT_PROFILE, TEXAS_DRUMS_API_KEY, _Profile.username, _Profile.password, phone.text];
    NSLog(@"%@", API_Call);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *get = [[[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding] autorelease];
    
    if([get isEqualToString:_200OK]){
        //set _Profile phone and set defaults in order to keep internal data in sync per startups
        _Profile.phonenumber = phone.text;
        
        //inform user of successful update and pop screen
        [self performSelectorOnMainThread:@selector(displayText:) withObject:@"Your phone number has been updated." waitUntilDone:YES];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendToProfileView) userInfo:nil repeats:NO];
    }
    else if([get isEqualToString:@""]){
        [self performSelectorOnMainThread:@selector(displayText:) withObject:@"Could not update phone number." waitUntilDone:YES];
    }
    
}

@end
