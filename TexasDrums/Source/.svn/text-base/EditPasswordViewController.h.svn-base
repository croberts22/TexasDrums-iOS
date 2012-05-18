//
//  EditPasswordViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface EditPasswordViewController : UIViewController<UITextFieldDelegate> {
    IBOutlet UITextField <UITextFieldDelegate> *original_password;
    IBOutlet UITextField <UITextFieldDelegate> *a_new_password;
    IBOutlet UITextField <UITextFieldDelegate> *a_new_password_again;
    IBOutlet UILabel *length_constraint;
    IBOutlet UILabel *alpha_constraint;
    IBOutlet UILabel *numerical_constraint;
    IBOutlet UILabel *status;
    IBOutlet UIButton *background_button;
}

@property (nonatomic, retain) UITextField <UITextFieldDelegate> *original_password;
@property (nonatomic, retain) UITextField <UITextFieldDelegate> *a_new_password;
@property (nonatomic, retain) UITextField <UITextFieldDelegate> *a_new_password_again;
@property (nonatomic, retain) UILabel *length_constraint;
@property (nonatomic, retain) UILabel *alpha_constraint;
@property (nonatomic, retain) UILabel *numerical_constraint;
@property (nonatomic, retain) UILabel *status;
@property (nonatomic, retain) UIButton *background_button;


- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)removeKeyboard;
- (IBAction)backgroundButtonPressed:(id)sender;
- (void)displayText:(NSString *)text;
- (IBAction)submitButtonPressed:(id)sender;
- (void)sendToProfileView;
- (void)updatePassword:(NSString *)password;

@end
