//
//  SingleMemberView.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/27/11.
//  Copyright 2011 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Common.h"


@interface SingleMemberView : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate> {
    IBOutlet UITableViewCell *memberNameCell;
    IBOutlet UITableView *memberData;
    IBOutlet UILabel *name;
    NSString *firstname;
    NSString *nickname;
    NSString *lastname;
    NSString *classification;
    NSString *amajor;
    NSString *hometown;
    NSString *quote;
    
    //members only
    NSString *phonenumber;
    NSString *email;
    
    NSArray *data;
    NSArray *categories;
}

@property (nonatomic, retain) UITableViewCell *memberNameCell;
@property (nonatomic, retain) UITableView *memberData;
@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) NSString *firstname;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *lastname;
@property (nonatomic, retain) NSString *classification;
@property (nonatomic, retain) NSString *amajor;
@property (nonatomic, retain) NSString *hometown;
@property (nonatomic, retain) NSString *quote;
@property (nonatomic, retain) NSString *phonenumber;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) NSArray *categories;

@end
