//
//  EditEmailViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface EditEmailViewController : UIViewController<UITextFieldDelegate> {
    IBOutlet UITextField <UITextFieldDelegate> *email;
    IBOutlet UIButton *submit;
    IBOutlet UIButton *backgroundButton;
    IBOutlet UILabel *status;
}

@property (nonatomic, retain) UITextField <UITextFieldDelegate> *email;
@property (nonatomic, retain) UIButton *submit;
@property (nonatomic, retain) UIButton *backgroundButton;
@property (nonatomic, retain) UILabel *status;


- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)backgroundButtonPressed:(id)sender;
- (void)displayText:(NSString *)text;
- (void)removeKeyboard;
- (void)removeError;
- (void)sendToProfileView;

@end
