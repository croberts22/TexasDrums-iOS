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
#import "TexasDrumsGetProfile.h"
#import "TexasDrumsAppDelegate.h"
#import "CJSONDeserializer.h"

@implementation MemberLoginViewController

@synthesize username, password, cancel, login, background, navbar, delegate;

#pragma mark - Memory Management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        delegate = (TexasDrumsAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)dealloc
{
    [username release];
    [password release];
    [cancel release];
    [login release];
    [super dealloc];
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
    [[GANTracker sharedTracker] trackPageview:@"Member Login (MemberLoginView)" withError:nil];
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

- (void)parseProfile:(NSDictionary *)results {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(_Profile == nil){
        //TDLog(@"results: %@", results);
        _Profile = [[Profile alloc] init];
        
        _Profile.firstname = [results objectForKey:@"firstname"];
        [defaults setObject:_Profile.firstname forKey:@"firstname"];
        
        _Profile.lastname = [results objectForKey:@"lastname"];
        [defaults setObject:_Profile.lastname forKey:@"lastname"];
        
        _Profile.email = [results objectForKey:@"email"];
        [defaults setObject:_Profile.email forKey:@"email"];
        
        _Profile.birthday = [results objectForKey:@"birthday"];
        [defaults setObject:_Profile.birthday forKey:@"birthday"];
        
        _Profile.lastlogin = [results objectForKey:@"lastlogin"];
        [defaults setObject:_Profile.lastlogin forKey:@"lastlogin"];
        
        _Profile.paid = [[results objectForKey:@"paid"] boolValue];
        [defaults setBool:_Profile.paid forKey:@"paid"];
        
        // This shouldn't be saved, and will not be able to be saved in the new
        // implementation of the database.
#warning - backend issue; needs to retrieve the hash.
        _Profile.password = [results objectForKey:@"password"];
        [defaults setObject:_Profile.password forKey:@"password"];
        
        _Profile.phonenumber = [results objectForKey:@"phonenumber"];
        [defaults setObject:_Profile.phonenumber forKey:@"phonenumber"];
        
        _Profile.section = [results objectForKey:@"section"];
        [defaults setObject:_Profile.section forKey:@"section"];
        
        _Profile.sl = [[results objectForKey:@"sl"] boolValue];
        _Profile.instructor = [[results objectForKey:@"instructor"] boolValue];
        _Profile.admin = [[results objectForKey:@"admin"] boolValue];
        
        _Profile.status = [results objectForKey:@"status"];
        [defaults setObject:_Profile.status forKey:@"status"];
        
        _Profile.username = [results objectForKey:@"username"];
        [defaults setObject:_Profile.username forKey:@"username"];
        
        _Profile.valid = [[results objectForKey:@"valid"] boolValue];
        [defaults setBool:_Profile.valid forKey:@"valid"];
        
        _Profile.years = [results objectForKey:@"years"];
        [defaults setObject:_Profile.years forKey:@"years"];
    }
    
    if(_Profile.sl){
        [defaults setBool:YES forKey:@"SL"];
    }
    else [defaults setBool:NO forKey:@"SL"]; 
    
    if(_Profile.instructor){
        [defaults setBool:YES forKey:@"instructor"];
    }
    else [defaults setBool:NO forKey:@"instructor"];
    
    if(_Profile.admin){
        [defaults setBool:YES forKey:@"admin"];
    }
    else [defaults setBool:NO forKey:@"admin"];
    
    [defaults setBool:YES forKey:@"member"];
    
    [defaults setBool:YES forKey:@"member"];
    [defaults setBool:YES forKey:@"login_valid"];
    
    TDLog(@"Profile for user '%@' has been fetched and saved.", username.text);
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
            if([[results objectForKey:@"status"] isEqualToString:_404UNAUTHORIZED]) {
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
