//
//  EditNameViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TexasDrumsAPIConnection.h"

@interface EditNameViewController : TexasDrumsViewController<UITextFieldDelegate, TexasDrumsAPIConnection> {
    IBOutlet UITextField *firstname;
    IBOutlet UITextField *lastname;
    IBOutlet UIButton *submit;
    IBOutlet UILabel *status;
}

@property (nonatomic, retain) UITextField *firstname;
@property (nonatomic, retain) UITextField *lastname;
@property (nonatomic, retain) UIButton *submit;
@property (nonatomic, retain) UILabel *status;

- (IBAction)submitButtonPressed:(id)sender;
- (void)removeKeyboard;
- (void)displayText:(NSString *)text;
- (void)removeError;
- (void)sendToProfileView;
- (BOOL)checkConstraints;

@end
