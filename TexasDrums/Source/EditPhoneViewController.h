//
//  EditPhoneViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TexasDrumsAPIConnection.h"

@interface EditPhoneViewController : UIViewController<UITextFieldDelegate, TexasDrumsAPIConnection> {
    IBOutlet UITextField *phone;
    IBOutlet UIButton *submit;
    IBOutlet UIButton *background_button;
    IBOutlet UILabel *status;
}

@property (nonatomic, retain) UITextField *phone;
@property (nonatomic, retain) UIButton *submit;
@property (nonatomic, retain) UIButton *background_button;
@property (nonatomic, retain) UILabel *status;

- (IBAction)backgroundButtonPressed:(id)sender;
- (void)displayText:(NSString *)text;
- (void)removeError;
- (IBAction)submitButtonPressed:(id)sender;
- (void)sendToProfileView;
- (void)updatePhone;

@end
