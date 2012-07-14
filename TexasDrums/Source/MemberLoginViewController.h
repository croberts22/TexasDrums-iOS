//
//  MemberLoginViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/30/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TexasDrumsAPIConnection.h"

@interface MemberLoginViewController : UIViewController<TexasDrumsAPIConnection, UITextFieldDelegate, NSURLConnectionDelegate> {
    IBOutlet UITextField <UITextFieldDelegate> *username;
    IBOutlet UITextField <UITextFieldDelegate> *password;
    IBOutlet UIBarButtonItem *cancel;
    IBOutlet UIBarButtonItem *login;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UILabel *error_label;
    IBOutlet UIButton *background;
    IBOutlet UINavigationItem *navbar;
    BOOL loggedIn;
    NSMutableData *received_data;
    NSMutableDictionary *dataFromConnectionsByTag;
}

@property (nonatomic, retain) IBOutlet UITextField *username;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *login;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) IBOutlet UILabel *error_label;
@property (nonatomic, retain) IBOutlet UIButton *background;
@property (nonatomic, retain) UINavigationItem *navbar;
@property (nonatomic, assign) BOOL loggedIn;
@property (nonatomic, retain) NSMutableData *received_data;
@property (nonatomic, retain) NSMutableDictionary *dataFromConnectionsByTag;

- (void)prepareToRemoveLoginScreen;
- (void)removeLoginScreen;
- (void)disableUI;
- (void)enableUI;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)backgroundPressed:(id)sender;
- (void)startConnection;
//- (void)checkLoginResponse:(NSData *)data;
- (void)getProfileData;
- (void)parseProfile:(NSDictionary *)results;
- (void)displayText:(NSString *)text;
- (void)removeError;

@end
