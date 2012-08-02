//
//  ProfileViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 8/9/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Profile;

@interface ProfileViewController : UIViewController {
    IBOutlet UITableView *profileTable;
}

@property (nonatomic, retain) UITableView *profileTable;

@end
