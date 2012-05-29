//
//  TexasDrumsWebViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 4/16/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TexasDrumsWebViewController : UIViewController<UIWebViewDelegate> {
    IBOutlet UIWebView<UIWebViewDelegate> *browser;
    IBOutlet UIBarButtonItem *fixedSpaceLeft;
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UIBarButtonItem *fixedSpaceMiddle;
    IBOutlet UIBarButtonItem *nextButton;
    IBOutlet UIBarButtonItem *fixedSpaceRight;
    IBOutlet UIBarButtonItem *refreshButton;
    IBOutlet UIToolbar *toolbar;
    UIActivityIndicatorView *indicator;
    NSMutableArray *toolbarItems;
    NSURLRequest *url;
    NSString *the_title;
}

@property (nonatomic, retain) UIWebView<UIWebViewDelegate> *browser;
@property (nonatomic, retain) UIBarButtonItem *fixedSpaceLeft;
@property (nonatomic, retain) UIBarButtonItem *backButton;
@property (nonatomic, retain) UIBarButtonItem *fixedSpaceMiddle;
@property (nonatomic, retain) UIBarButtonItem *nextButton;
@property (nonatomic, retain) UIBarButtonItem *fixedSpaceRight;
@property (nonatomic, retain) UIBarButtonItem *refreshButton;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) NSMutableArray *toolbarItems;
@property (nonatomic, retain) NSURLRequest *url;
@property (nonatomic, retain) NSString *the_title;

- (IBAction)refreshButtonPressed:(id)sender;

@end
