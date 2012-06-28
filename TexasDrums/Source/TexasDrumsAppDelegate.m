//
//  TexasDrumsAppDelegate.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "TexasDrumsAppDelegate.h"
#import "MemberLoginViewController.h"
#import "CJSONDeserializer.h"
#import "GANTracker.h"
#import "Crittercism.h"

// Dispatch period in seconds
static const NSInteger kGANDispatchPeriodSec = 10;

@implementation TexasDrumsAppDelegate

@synthesize window=_window;
@synthesize tabBarController=_tabBarController;
@synthesize splashView, received_data;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
    [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-30605087-1"
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:nil];

    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *keys = [[[NSArray alloc] initWithObjects:@"login_username", @"login_password", @"login_valid", 
                                                      @"SL", @"instructor", @"admin", @"member", nil] autorelease];
    NSArray *objects = [[[NSArray alloc] initWithObjects:@"", @"", @"NO", @"NO", @"NO", @"NO", @"NO", nil] autorelease];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [defaults registerDefaults:appDefaults];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
	splashView.image = [UIImage imageNamed:@"Default.png"]; //image is default.png
	[_window addSubview:splashView]; //adds a subview so image can be seen; bring it forward
	[_window bringSubviewToFront:splashView];
	[UIView beginAnimations:nil context:nil]; //animations are stoic at at this point
	[UIView setAnimationDuration:0.75]; //set duration of animation to 2 seconds
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_window cache:YES];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
	splashView.alpha = 0.0;
	[UIView commitAnimations];
    
    [self startConnection];
    
    [Crittercism initWithAppID:@"4fca4280067e7c223100000d" andKey:@"qmqprnyvfwt1txkj96zhlofnksr0" andSecret:@"pat1ikup9agryyrlhh7mt2cv5k8gsnjx" andMainViewController:self.window.rootViewController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [splashView release];
    [super dealloc];
}


- (void)startConnection {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(![defaults boolForKey:@"login_valid"]){
        NSLog(@"User has not logged in. Not fetching profile.");
        return;
    }
    
    NSString *username = [defaults objectForKey:@"login_username"];
    NSString *password = [defaults objectForKey:@"login_password"];
    
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@&username=%@&password=%@", TEXAS_DRUMS_API_PROFILE, TEXAS_DRUMS_API_KEY, username, password];
    NSLog(@"%@", API_Call);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLConnection *urlconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if(urlconnection) {
        received_data = [[NSMutableData data] retain];
    }
}

- (void)createProfile:(NSDictionary *)results {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([results isEqual:@"404"] || [results count] == 0){
        NSLog(@"Could not fetch current profile. Using the one stored in NSUserDefaults.");
        return;
    }
    
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
    
    NSLog(@"Profile fetched and saved.");
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
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
    // release the connection, and the data object
    [connection release];
    [received_data release];
    
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
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:received_data error:&error];
    
    [self createProfile:results];
    
    NSLog(@"Succeeded! Received %d bytes of data.", [received_data length]);
    
    // release the connection, and the data object
    [connection release];
    [received_data release];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
