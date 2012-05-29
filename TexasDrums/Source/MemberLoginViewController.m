    //
//  MemberLoginViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/30/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "MemberLoginViewController.h"
#import "Common.h"
#import "Profile.h"
#import "CJSONDeserializer.h"
#import "GANTracker.h"
#import "NSURLConnectionWithTag.h"

#define _200OK (@"200 OK")

typedef enum {
    LoginConnection = 0,
    ProfileConnection = 1,
} ConnectionTypes;

@implementation MemberLoginViewController

@synthesize username, password, cancel, login, indicator, error_label, background, navbar, received_data, loggedIn, dataFromConnectionsByTag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [error_label release];
    [indicator release];
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

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navbar.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont fontWithName:@"Georgia-Bold" size:20];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleView.textColor = [UIColor whiteColor]; 
        
        self.navbar.titleView = titleView;
        [titleView release];
    }
    titleView.text = title;
    [titleView sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated {
    [[GANTracker sharedTracker] trackPageview:@"Member Login (MemberLoginView)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Login"];
    self.error_label.alpha = 0.0;
    username.delegate = self;
    password.delegate = self;
    loggedIn = FALSE;
    
    if(dataFromConnectionsByTag == nil){
        dataFromConnectionsByTag = [[[NSMutableDictionary alloc] init] autorelease];
    }
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


/************************
 * User Defined Methods
 ************************/

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

- (void)prepareToRemoveLoginScreen {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(removeLoginScreen) userInfo:nil repeats:NO];
    [pool release];
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
    [self disableUI];
    [self removeError];
    [indicator startAnimating];
    [self performSelectorInBackground:@selector(startConnection) withObject:nil];
}

- (IBAction)backgroundPressed:(id)sender {
    [username resignFirstResponder];
    [password resignFirstResponder];
}

- (void)startConnection {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSError *error = nil;
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&username=%@&password=%@&device=mobile", TEXAS_DRUMS_API_LOGIN, TEXAS_DRUMS_API_KEY, username.text, password.text];
    
    NSLog(@"%@", API_Call);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSString *get = [[[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding] autorelease];
    
    if(DEBUG_MODE) NSLog(@"Member Login response from server: %@", response);
    
    if([get isEqualToString:_200OK]) {
        [self performSelectorOnMainThread:@selector(getProfileData) withObject:nil waitUntilDone:NO];
    }
    else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [self performSelectorOnMainThread:@selector(enableUI) withObject:nil waitUntilDone:NO];
        [defaults setObject:@"" forKey:@"login_username"];
        [defaults setObject:@"" forKey:@"login_password"];
        [defaults setBool:NO forKey:@"member"];
        [defaults setBool:NO forKey:@"login_valid"];
        [self displayText:@"Error: Incorrect username or password."];
    }
    [pool release];
}
/*
- (void)checkLoginResponse:(NSData *)data {
    NSString *response = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease]; 

    if(DEBUG_MODE) NSLog(@"Member Login response from server: %@", response);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([response isEqualToString:_200OK]){
        loggedIn = TRUE;
        [self getProfileData];
    }
    else{
        [self performSelectorOnMainThread:@selector(enableUI) withObject:nil waitUntilDone:NO];
        [defaults setObject:@"" forKey:@"login_username"];
        [defaults setObject:@"" forKey:@"login_password"];
        [defaults setBool:NO forKey:@"member"];
        [defaults setBool:NO forKey:@"login_valid"];
        [self displayText:@"Error: Incorrect username or password."];
    }
}
 */

- (void)getProfileData {
    // Login first
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&username=%@&password=%@", TEXAS_DRUMS_API_PROFILE, TEXAS_DRUMS_API_KEY, username.text, password.text];
    NSLog(@"%@", API_Call);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLConnection *urlconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if(urlconnection) {
        received_data = [[NSMutableData data] retain];
    }
}

- (void)parseProfile:(NSDictionary *)results {
    //store data into _Profile
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(_Profile == nil){
        //NSLog(@"results: %@", results);
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
    
    [defaults setObject:username.text forKey:@"login_username"];
    [defaults setObject:password.text forKey:@"login_password"];
    
    [defaults setBool:YES forKey:@"member"];
    [defaults setBool:YES forKey:@"login_valid"];

    [self performSelectorOnMainThread:@selector(displayText:) withObject:@"You are now logged in." waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(prepareToRemoveLoginScreen) withObject:nil waitUntilDone:NO];
    [indicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    
    NSLog(@"Profile fetched and saved.");
}

- (void)displayText:(NSString *)text {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.error_label.text = text;
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.50];
    self.error_label.alpha = 1.0;
	[UIView commitAnimations];
    [pool release];
}

- (void)removeError {
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.5];
    self.error_label.alpha = 0.0;
	[UIView commitAnimations];
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [received_data setLength:0];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to received_data.
    [received_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" 
                                                    message:[error localizedDescription] 
                                                   delegate:self 
                                          cancelButtonTitle:@":( Okay" 
                                          otherButtonTitles:nil, nil];
    
    [alert show];
    [alert release];
    
    [indicator stopAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // release the connection, and the data object
    [connection release];
    [received_data release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;

    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:received_data error:&error];
    [self parseProfile:results];
    
    NSLog(@"Succeeded! Received %d bytes of data", [received_data length]);

    // release the connection, and the data object
    [connection release];
    [received_data release];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
