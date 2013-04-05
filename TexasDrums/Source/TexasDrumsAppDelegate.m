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
#import "GANTracker.h"
#import "SWRevealViewController.h"

#import "NewsViewController.h"
#import "MenuViewController.h"

// Dispatch period in seconds
static const NSInteger kGANDispatchPeriodSec = 10;

@interface TexasDrumsAppDelegate ()
- (void)registerAppDefaults;
- (void)fetchUserProfile;
- (void)forceLogout;
@end

@implementation TexasDrumsAppDelegate

@synthesize window=_window;
@synthesize tabBarController=_tabBarController;
@synthesize splashView;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Initialize Google Analytics.
    [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-30605087-1"
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:nil];
    // Initialize Crittercism.
    [Crittercism initWithAppID:@"4fca4280067e7c223100000d"
                        andKey:@"qmqprnyvfwt1txkj96zhlofnksr0"
                     andSecret:@"pat1ikup9agryyrlhh7mt2cv5k8gsnjx"
         andMainViewController:self.window.rootViewController];
    
    // Fire up Crashlytics.
    [Crashlytics startWithAPIKey:@"c01aa6f0d36b5000da6aa8c83dda558c23be54f8"];
    
    // Get User Profile (if already logged in previously).
    [self fetchUserProfile];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window = window;
    
    // Set AVAudio properties to play audio files on the silent thread of AVFoundation.
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

    [self registerAppDefaults];
    
    NewsViewController *NV = [[NewsViewController alloc] initWithNibName:@"NewsView" bundle:[NSBundle mainBundle]];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:NV];
    
    MenuViewController *menuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:[NSBundle mainBundle]];
    
    SWRevealViewController *rootController = [[SWRevealViewController alloc] initWithRearViewController:menuViewController frontViewController:navigationController];
    rootController.delegate = self;
    
    self.viewController = rootController;
    
    self.window.rootViewController = self.viewController;
    
//    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
//    if ([self.tabBarController.tabBar respondsToSelector:@selector(setSelectedImageTintColor:)]) {
//        self.tabBarController.tabBar.selectedImageTintColor = [UIColor TexasDrumsOrangeColor];
//    }
    
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
    
    [UIView animateWithDuration:0.3f animations:^{
        splashView.alpha = 0.0;
    }];
    
    return YES;
}

- (void)registerAppDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"login_valid", @"SL", @"instructor", @"admin", @"member", nil];
    NSArray *objects = [[NSArray alloc] initWithObjects:@"NO", @"NO", @"NO", @"NO", @"NO", nil];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [defaults registerDefaults:appDefaults];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
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
    [defaults synchronize];
    
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
    [defaults synchronize];
    
    TDLog(@"Profile for user '%@' has been fetched and saved.", [UserProfile sharedInstance].username);
}

- (void)destroyProfile {
    TDLog(@"Destroying profile.");
    [[UserProfile sharedInstance] destroyProfile];
}

#pragma mark - TexasDrumsRequest Delegate Methods

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

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TexasDrums" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TexasDrums.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
