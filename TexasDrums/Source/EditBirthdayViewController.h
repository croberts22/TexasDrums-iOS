//
//  EditBirthdayViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditBirthdayViewController : UIViewController<NSURLConnectionDelegate> {
    IBOutlet UIDatePicker *picker;
    IBOutlet UILabel *birthdayLabel;
    IBOutlet UILabel *status;
    IBOutlet UIButton *submitButton;
    NSString *updatedBirthday;
    NSMutableData *received_data;
}

@property (nonatomic, retain) UIDatePicker *picker;
@property (nonatomic, retain) UILabel *birthdayLabel;
@property (nonatomic, retain) UILabel *status;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) NSString *updatedBirthday;
@property (nonatomic, retain) NSMutableData *received_data;

- (IBAction)submitButtonPressed:(id)sender;

@end
