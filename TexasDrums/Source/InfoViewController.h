//
//  InfoViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 8/8/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface InfoViewController : TexasDrumsViewController<MFMailComposeViewControllerDelegate> {
    IBOutlet UITableView *aboutTable;
}

@property (nonatomic, retain) UITableView *aboutTable;

@end
