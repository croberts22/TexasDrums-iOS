//
//  AddressBookMemberViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 4/25/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Profile.h"
#import "Common.h"

@interface AddressBookMemberViewController : UIViewController<MFMailComposeViewControllerDelegate, UIActionSheetDelegate> {
    IBOutlet UILabel *member_name;
    IBOutlet UILabel *member_status;
    IBOutlet UILabel *member_header;
    IBOutlet UITableView *member_contact;
    Profile *profile;
}

@property (nonatomic, retain) UILabel *member_name;
@property (nonatomic, retain) UILabel *member_status;
@property (nonatomic, retain) UILabel *member_header;
@property (nonatomic, retain) UITableView *member_contact;
@property (nonatomic, retain) Profile *profile;

@end
