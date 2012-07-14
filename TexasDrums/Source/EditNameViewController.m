//
//  EditNameViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "EditNameViewController.h"
#import "GANTracker.h"

@implementation EditNameViewController

#define _403 (@"403 ERROR: No input given")

@synthesize firstname, lastname, submit, status;

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
    [[GANTracker sharedTracker] trackPageview:@"Edit Name (EditNameView)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Edit Name"];
    status.alpha = 0.0f;
    
    firstname.delegate = self;
    lastname.delegate = self;
    
    firstname.text = _Profile.firstname;
    lastname.text = _Profile.lastname;

    firstname.font = [UIFont fontWithName:@"Georgia" size:14];
    lastname.font = [UIFont fontWithName:@"Georgia" size:14];
    
    firstname.textColor = [UIColor lightGrayColor];
    lastname.textColor = [UIColor lightGrayColor];
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
    if(textField == firstname){
        [lastname becomeFirstResponder];
    }
    else{ //lastname is responder; submit
        [textField resignFirstResponder];
        [self submitButtonPressed:nil];
    }
    
    return YES;
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

- (IBAction)submitButtonPressed:(id)sender {
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
    //NSError *error = nil;
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&username=%@&password=%@&firstname=%@&lastname=%@", TEXAS_DRUMS_API_EDIT_PROFILE, TEXAS_DRUMS_API_KEY, _Profile.username, _Profile.password, firstname.text, lastname.text];
    NSLog(@"%@", API_Call);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *get = [[[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding] autorelease];
    
    if([get isEqualToString:_200OK]){
        _Profile.firstname = firstname.text;
        _Profile.lastname = lastname.text;
        
        [self performSelectorOnMainThread:@selector(displayText:) withObject:@"Your name has been updated." waitUntilDone:YES];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendToProfileView) userInfo:nil repeats:NO];
    }
    else if([get isEqualToString:@""]){
        [self performSelectorOnMainThread:@selector(displayText:) withObject:@"Could not update name." waitUntilDone:YES];
    }
    //more error management here
}

@end
