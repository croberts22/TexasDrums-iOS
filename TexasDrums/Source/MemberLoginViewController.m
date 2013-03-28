    //
//  MemberLoginViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/30/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "MemberLoginViewController.h"
#import "Profile.h"
#import "TexasDrumsGetMemberLogin.h"
#import "TexasDrumsAppDelegate.h"
#import "CJSONDeserializer.h"

@interface MemberLoginViewController()

- (void)removeLoginScreen;
- (void)disableUI;
- (void)enableUI;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;

@end

@implementation MemberLoginViewController

@synthesize username, password, cancel, login, background, navbar, delegate;

#pragma mark - Memory Management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        delegate = (TexasDrumsAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Login"];
    
    // Set properties.
    username.delegate = self;
    password.delegate = self;
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


#pragma mark - UI Methods

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navbar.titleView;
    if (!titleView) {
        titleView = [UILabel TexasDrumsNavigationBar];
        self.navbar.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}

- (void)dismissWithError {
    [self enableUI];
    [SVProgressHUD showErrorWithStatus:@"Could not log in."];    
}

- (void)dismissWithSuccess {
    [SVProgressHUD showSuccessWithStatus:@"You are now logged in."];
}

- (void)removeLoginScreen {
    [self dismissModalViewControllerAnimated:YES];  
}

- (void)disableUI {
    self.cancel.enabled = NO;
    self.login.enabled = NO;
    self.username.enabled = NO;
    self.password.enabled = NO;
}

- (void)enableUI {
    self.cancel.enabled = YES;
    self.login.enabled = YES;
    self.username.enabled = YES;
    self.password.enabled = YES;
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self removeLoginScreen];
}

- (IBAction)loginButtonPressed:(id)sender {
    [self connect];
}

- (IBAction)backgroundPressed:(id)sender {
    [username resignFirstResponder];
    [password resignFirstResponder];
}

- (void)connect {
    [self disableUI];
    TexasDrumsGetMemberLogin *get = [[TexasDrumsGetMemberLogin alloc] initWithUsername:username.text andPassword:password.text];
    get.delegate = self;
    [get startRequest];
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{	
	if(textField == username){
		[password becomeFirstResponder];
	}
	else {
		[password resignFirstResponder];
        [self loginButtonPressed:nil];
	}
    
	return YES;
}

#pragma mark - TexasDrumsRequestDelegate Methods


#warning - need a better backend solution.
- (void)request:(TexasDrumsRequest *)request receivedData:(id)data {
    TDLog(@"Login request succeeded.");
    
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:data error:&error];
    
    if([results count] > 0) {
        // Check if the response is just a dictionary value of one.
        // This implies that the key value pair follows the format:
        // status -> 'message'
        // We use respondsToSelector since the API returns a dictionary
        // of length one for any status messages, but an array of 
        // dictionary responses for valid data. 
        // CJSONDeserializer interprets actual data as NSArrays.
        if([results respondsToSelector:@selector(objectForKey:)] ){
            if([[results objectForKey:@"status"] isEqualToString:_404_UNAUTHORIZED]) {
                TDLog(@"Unable to retrieve profile. Request returned: %@", [results objectForKey:@"status"]);
                [self dismissWithError];
                return;
            }
        }
        
        TDLog(@"Logged in successfully. Establishing profile...");
        // Deserialize JSON results and parse them into News objects.
        [self.delegate createProfile:results];
        [self dismissWithSuccess];
        [self removeLoginScreen];
    }
    else {
        TDLog(@"Failed to log in.");
        [self dismissWithError];
    }
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    TDLog(@"Login request error: %@", error);
    
    [self dismissWithError];
}


@end
