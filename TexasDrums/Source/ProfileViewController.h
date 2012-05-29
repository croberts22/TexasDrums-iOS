//
//  ProfileViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 8/9/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface ProfileViewController : UIViewController {
    IBOutlet UITableView *profileTable;
}

extern Profile *_Profile;

@property (nonatomic, retain) UITableView *profileTable;

@end
