//
//  TexasDrumsAppDelegate.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Crashlytics/Crashlytics.h>

#import "SWRevealViewController.h"

@interface TexasDrumsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, TexasDrumsRequestDelegate, SWRevealViewControllerDelegate> {
    UIImageView *splashView;
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) SWRevealViewController *viewController;

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, strong) UIImageView *splashView;

- (void)createProfile:(NSDictionary *)results;
- (void)destroyProfile;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
