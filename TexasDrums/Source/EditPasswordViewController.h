//
//  EditPasswordViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TexasDrumsAPIConnection.h"

@interface EditPasswordViewController : UIViewController<UITextFieldDelegate, TexasDrumsAPIConnection> {
    IBOutlet UITextField *original_password;
    IBOutlet UITextField *a_new_password;
    IBOutlet UITextField *a_new_password_again;
    IBOutlet UILabel *length_constraint;
    IBOutlet UILabel *alpha_constraint;
    IBOutlet UILabel *numerical_constraint;
    IBOutlet UILabel *status;
    IBOutlet UIButton *background_button;
}

@property (nonatomic, retain) UITextField *original_password;
@property (nonatomic, retain) UITextField *a_new_password;
@property (nonatomic, retain) UITextField *a_new_password_again;
@property (nonatomic, retain) UILabel *length_constraint;
@property (nonatomic, retain) UILabel *alpha_constraint;
@property (nonatomic, retain) UILabel *numerical_constraint;
@property (nonatomic, retain) UILabel *status;
@property (nonatomic, retain) UIButton *background_button;

- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)backgroundButtonPressed:(id)sender;
- (void)removeKeyboard;
- (void)displayText:(NSString *)text;
- (void)removeError;
- (void)sendToProfileView;
- (BOOL)checkConstraints;

@end
