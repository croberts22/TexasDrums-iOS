//
//  AddGigViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 7/18/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GigRequirementsViewController.h"
#import "MemberListViewController.h"

@class DateViewController;

@interface AddGigViewController : TexasDrumsViewController<UITextFieldDelegate, UITextViewDelegate, GigRequirementsViewControllerDelegate, MemberListViewControllerDelegate> {
    IBOutlet UIScrollView *detailView;
    IBOutlet UIButton *backgroundButton_;
    IBOutlet UITextField *name_;
    IBOutlet UILabel *date_;
    IBOutlet UIButton *dateButton_;
    IBOutlet UILabel *peopleRequired_;
    IBOutlet UIButton *peopleButton_;
    IBOutlet UITextField *location_;
    IBOutlet UITextView *description_;
    IBOutlet UILabel *whosIn_;
    NSArray *currentSelection_;
    NSMutableArray *currentPeople_;
    DateViewController *dateViewController_;
}

@property (nonatomic, retain) UIScrollView *detailView;
@property (nonatomic, retain) UIButton *backgroundButton;
@property (nonatomic, retain) UITextField *name;
@property (nonatomic, retain) UILabel *date;
@property (nonatomic, retain) UIButton *dateButton;
@property (nonatomic, retain) UILabel *peopleRequired;
@property (nonatomic, retain) UIButton *peopleButton;
@property (nonatomic, retain) UITextField *location;
@property (nonatomic, retain) UITextView *description;
@property (nonatomic, retain) UILabel *whosIn;
@property (nonatomic, copy) NSArray *currentSelection;
@property (nonatomic, retain) NSMutableArray *currentPeople;
@property (nonatomic, retain) DateViewController *dateViewController;

@end
