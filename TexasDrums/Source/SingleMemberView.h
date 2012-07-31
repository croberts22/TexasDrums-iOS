//
//  SingleMemberView.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/27/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class RosterMember;

@interface SingleMemberView : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate> {
    RosterMember *member;    
    IBOutlet UILabel *memberName;
    IBOutlet UITableView *memberData;
    NSArray *data;
    NSArray *categories;
}

@property (nonatomic, retain) RosterMember *member;
@property (nonatomic, retain) UILabel *memberName;
@property (nonatomic, retain) UITableView *memberData;
@property (nonatomic, copy) NSArray *data;
@property (nonatomic, copy) NSArray *categories;

@end
