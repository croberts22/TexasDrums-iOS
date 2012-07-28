//
//  EditBirthdayViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 10/13/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TexasDrumsAPIConnection.h"

@protocol TexasDrumsAPIConnection;

@interface EditBirthdayViewController : UIViewController<TexasDrumsAPIConnection> {
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
- (void)displayText:(NSString *)text;
- (void)removeError;
- (void)sendToProfileView;
- (void)updateLabel:(id)sender;
- (BOOL)checkConstraints;
- (NSString *)parseDatabaseString;
- (NSString *)convertIntToMonth:(int)month;
- (NSString *)prepareDateString;

@end
