//
//  StaffMemberViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 4/20/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "StaffMember.h"

@interface StaffMemberViewController : UIViewController<UIWebViewDelegate, MFMailComposeViewControllerDelegate> {
    StaffMember *member;
    UIImageView *picture;
    UIWebView *bio;
    UIScrollView *scroll;
    BOOL loadBio;
    //IBOutlet UIActivityIndicatorView *indicator;
}

@property (nonatomic, retain) StaffMember *member;
@property (nonatomic, retain) UIImageView *picture;
@property (nonatomic, retain) UIWebView *bio;
@property (nonatomic, retain) UIScrollView *scroll;
@property (nonatomic, assign) BOOL loadBio;
//@property (nonatomic, retain) UIActivityIndicatorView *indicator;

@end
