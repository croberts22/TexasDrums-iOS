//
//  AddGigViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 7/18/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddGigViewController : UIViewController<UITextFieldDelegate> {
    IBOutlet UINavigationItem *navigationBar;
    IBOutlet UIScrollView *detailView;
    IBOutlet UIButton *backgroundButton_;
    IBOutlet UITextField *name_;
    IBOutlet UILabel *date_;
    IBOutlet UIButton *dateButton_;
    IBOutlet UITextField *location_;
    IBOutlet UITextView *description_;
}

@property (nonatomic, retain) UINavigationItem *navigationBar;
@property (nonatomic, retain) UIScrollView *detailView;
@property (nonatomic, retain) UIButton *backgroundButton;
@property (nonatomic, retain) UITextField *name;
@property (nonatomic, retain) UILabel *date;
@property (nonatomic, retain) UIButton *dateButton;
@property (nonatomic, retain) UITextField *location;
@property (nonatomic, retain) UITextView *description;

@end
