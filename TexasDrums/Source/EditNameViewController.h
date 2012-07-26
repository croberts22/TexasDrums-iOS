//
//  EditNameViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "TexasDrumsAPIConnection.h"

@interface EditNameViewController : UIViewController<UITextFieldDelegate, TexasDrumsAPIConnection> {
    IBOutlet UITextField *firstname;
    IBOutlet UITextField *lastname;
    IBOutlet UIButton *submit;
    IBOutlet UILabel *status;
}

@property (nonatomic, retain) UITextField *firstname;
@property (nonatomic, retain) UITextField *lastname;
@property (nonatomic, retain) UIButton *submit;
@property (nonatomic, retain) UILabel *status;

- (void)removeKeyboard;
- (void)displayText:(NSString *)text;
- (void)removeError;

- (IBAction)submitButtonPressed:(id)sender;

@end
