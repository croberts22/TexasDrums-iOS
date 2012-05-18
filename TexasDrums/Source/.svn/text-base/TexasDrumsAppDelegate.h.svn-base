//
//  TexasDrumsAppDelegate.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface TexasDrumsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, NSURLConnectionDelegate> {
    UIImageView *splashView;
    NSMutableData *received_data;
}

extern Profile *_Profile;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) UIImageView *splashView;
@property (nonatomic, retain) NSMutableData *received_data;

- (void)startConnection;
- (void)createProfile:(NSDictionary *)results;

@end
