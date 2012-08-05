//
//  DateViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 7/22/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateViewController : UIViewController {
    NSDate *currentDate;
    IBOutlet UIDatePicker *datePicker;
}

@property (nonatomic, retain) NSDate *currentDate;
@property (nonatomic, retain) UIDatePicker *datePicker;

@end
