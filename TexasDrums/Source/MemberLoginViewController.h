//
//  MemberLoginViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/30/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TexasDrumsAPIConnection.h"

@protocol TexasDrumsAPIConnection;

@class TexasDrumsAppDelegate;

@interface MemberLoginViewController : UIViewController<TexasDrumsAPIConnection, UITextFieldDelegate> {
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UIBarButtonItem *cancel;
    IBOutlet UIBarButtonItem *login;
    IBOutlet UIButton *background;
    IBOutlet UINavigationItem *navbar;
    
    TexasDrumsAppDelegate *delegate;
}

@property (nonatomic, retain) IBOutlet UITextField *username;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *login;;
@property (nonatomic, retain) IBOutlet UIButton *background;
@property (nonatomic, retain) UINavigationItem *navbar;

@property (nonatomic, retain) TexasDrumsAppDelegate *delegate;

- (void)removeLoginScreen;
- (void)disableUI;
- (void)enableUI;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;
- (void)parseProfile:(NSDictionary *)results;

@end
