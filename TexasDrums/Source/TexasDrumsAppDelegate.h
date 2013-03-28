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

@property (strong, nonatomic) SWRevealViewController *viewController;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) UIImageView *splashView;

- (void)createProfile:(NSDictionary *)results;
- (void)destroyProfile;


@end
