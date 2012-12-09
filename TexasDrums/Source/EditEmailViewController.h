//
//  EditEmailViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TexasDrumsAPIConnection.h"

@protocol TexasDrumsAPIConnection;

@interface EditEmailViewController : TexasDrumsViewController<UITextFieldDelegate, TexasDrumsAPIConnection> {
    IBOutlet UITextField *email;
    IBOutlet UIButton *submit;
    IBOutlet UIButton *backgroundButton;
    IBOutlet UILabel *status;
}

@property (nonatomic, retain) UITextField *email;
@property (nonatomic, retain) UIButton *submit;
@property (nonatomic, retain) UIButton *backgroundButton;
@property (nonatomic, retain) UILabel *status;

- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)backgroundButtonPressed:(id)sender;
- (void)removeKeyboard;
- (void)displayText:(NSString *)text;
- (void)removeError;
- (void)sendToProfileView;
- (BOOL)checkConstraints;

@end
