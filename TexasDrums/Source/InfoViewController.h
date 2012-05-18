//
//  InfoViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 8/8/11.
//  Copyright 2011 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface InfoViewController : UIViewController<MFMailComposeViewControllerDelegate> {
    IBOutlet UITableView *aboutTable;
}

@property (nonatomic, retain) UITableView *aboutTable;

@end
