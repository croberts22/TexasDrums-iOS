//
//  EditNameViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface EditNameViewController : UIViewController<UITextFieldDelegate> {
    IBOutlet UITextField <UITextFieldDelegate> *firstname;
    IBOutlet UITextField <UITextFieldDelegate> *lastname;
    IBOutlet UIButton *submit;
    IBOutlet UILabel *status;
}

@property (nonatomic, retain) UITextField <UITextFieldDelegate> *firstname;
@property (nonatomic, retain) UITextField <UITextFieldDelegate> *lastname;
@property (nonatomic, retain) UIButton *submit;
@property (nonatomic, retain) UILabel *status;

- (void)removeKeyboard;
- (void)displayText:(NSString *)text;
- (void)removeError;

- (IBAction)submitButtonPressed:(id)sender;

@end
