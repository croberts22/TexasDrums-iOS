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
#import "Crittercism.h"
#import "TexasDrumsGetMemberLogin.h"

// Dispatch period in seconds
static const NSInteger kGANDispatchPeriodSec = 10;

@interface TexasDrumsAppDelegate ()
- (void)forceLogout;
@end

@implementation TexasDrumsAppDelegate

@synthesize window=_window;
@synthesize tabBarController=_tabBarController;
@synthesize splashView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Initialize Google Analytics.
    [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-30605087-1"
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:nil];
    // Initialize Crittercism.
    [Crittercism initWithAppID:@"4fca4280067e7c223100000d"
                        andKey:@"qmqprnyvfwt1txkj96zhlofnksr0"
                     andSecret:@"pat1ikup9agryyrlhh7mt2cv5k8gsnjx"
         andMainViewController:self.window.rootViewController];
    
    
    // Get User Profile (if already logged in previously).
    [self fetchUserProfile];
    
    // Set AVAudio properties to play audio files on the silent thread of AVFoundation.
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

    [self registerAppDefaults];

    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    if ([self.tabBarController.tabBar respondsToSelector:@selector(setSelectedImageTintColor:)]) {
        self.tabBarController.tabBar.selectedImageTintColor = [UIColor TexasDrumsOrangeColor];
    }
    
    splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    splashView.alpha = 1.0;
    if(SCREEN_HEIGHT > 480) {
        splashView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    }
    else {
        splashView.image = [UIImage imageNamed:@"Default.png"];
    }
	
	[_window addSubview:splashView];
	[_window bringSubviewToFront:splashView];
    
    [UIView animateWithDuration:0.5f animations:^{
        splashView.alpha = 0.0;
    }];
    
    return YES;
}

- (void)registerAppDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *keys = [[[NSArray alloc] initWithObjects:@"login_valid", @"SL", @"instructor", @"admin", @"member", nil] autorelease];
    NSArray *objects = [[[NSArray alloc] initWithObjects:@"NO", @"NO", @"NO", @"NO", @"NO", nil] autorelease];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [defaults registerDefaults:appDefaults];
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

#pragma mark - Data Methods

- (void)fetchUserProfile {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(![defaults boolForKey:@"login_valid"]){
        TDLog(@"User is not logged in. Not retrieving profile.");
        return;
    }
    
    NSString *username = [defaults objectForKey:@"username"];
    NSString *password = [defaults objectForKey:@"password"];
    
    TexasDrumsGetMemberLogin *get = [[TexasDrumsGetMemberLogin alloc] initWithUsername:username andPassword:password];
    get.delegate = self;
    [get startRequest];
}

- (void)forceLogout {
    TDLog(@"Forcing logout.");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"username"];
    [defaults setObject:@"" forKey:@"password"];
    [defaults setBool:NO forKey:@"login_valid"];
    
    [self destroyProfile];
}

- (void)createProfile:(NSDictionary *)results {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [[UserProfile sharedInstance] createProfile:results];
    
    [Crittercism setUsername:[UserProfile sharedInstance].username];
    
    [defaults setObject:[UserProfile sharedInstance].username forKey:@"username"];
    [defaults setObject:[UserProfile sharedInstance].hash forKey:@"password"];
    [defaults setBool:YES forKey:@"member"];
    [defaults setBool:YES forKey:@"login_valid"];
    
    TDLog(@"Profile for user '%@' has been fetched and saved.", [UserProfile sharedInstance].username);
}

- (void)destroyProfile {
    TDLog(@"Destroying profile.");
    [[UserProfile sharedInstance] destroyProfile];
}

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
                [self forceLogout];
                return;
            }
        }
        
        TDLog(@"Logged in successfully. Establishing profile...");
        // Deserialize JSON results and parse them into News objects.
        [self createProfile:results];
    }
    else {
        TDLog(@"Failed to log in. Forcing logout.");
        [self forceLogout];
    }
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    TDLog(@"Login request error: %@", error);
    [self forceLogout];
}


@end
