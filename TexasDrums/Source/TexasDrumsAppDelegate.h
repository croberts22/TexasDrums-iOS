//
//  TexasDrumsAppDelegate.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface TexasDrumsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIImageView *splashView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) UIImageView *splashView;

- (void)registerAppDefaults;
- (void)connect;
- (void)createProfile:(NSDictionary *)results;
- (void)destroyProfile;


@end
