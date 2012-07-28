//
//  TexasDrumsAppDelegate.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TexasDrumsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIImageView *splashView;
    NSMutableData *received_data;
}

extern Profile *_Profile;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) UIImageView *splashView;
@property (nonatomic, retain) NSMutableData *received_data;

- (void)createProfile:(NSDictionary *)results;
- (void)destroyProfile;


@end
