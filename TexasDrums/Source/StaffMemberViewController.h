//
//  StaffMemberViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 4/20/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class StaffMember;

@interface StaffMemberViewController : TexasDrumsViewController<UIWebViewDelegate, MFMailComposeViewControllerDelegate> {
    StaffMember *member;
    UIImageView *picture;
    UIWebView *bio;
    UIScrollView *scroll;
    BOOL loadBio;
}

@property (nonatomic, retain) StaffMember *member;
@property (nonatomic, retain) UIImageView *picture;
@property (nonatomic, retain) UIWebView *bio;
@property (nonatomic, retain) UIScrollView *scroll;
@property (nonatomic, assign) BOOL loadBio;

@end
