//
//  AboutUsViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 1/10/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface AboutUsViewController : UIViewController {
    IBOutlet UIImageView *image;
    IBOutlet UITextView *info;
    IBOutlet UIActivityIndicatorView *large_indicator;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UILabel *status;
    NSMutableData *received_data;
}

@property (nonatomic, retain) UIImageView *image;
@property (nonatomic, retain) UITextView *info;
@property (nonatomic, retain) UIActivityIndicatorView *large_indicator;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UILabel *status;
@property (nonatomic, retain) NSMutableData *received_data;

- (void)startIndicators;
- (void)stopLargeIndicator;
- (void)stopIndicator;
- (void)fetchAbout;
- (void)parseAboutData:(NSDictionary *)results;
- (void)loadImage:(NSString *)link;
- (void)displayImage:(UIImage *)image;
- (void)displayText:(NSString *)text;

@end
