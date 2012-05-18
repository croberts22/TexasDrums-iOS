//
//  ProfileViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 8/9/11.
//  Copyright 2011 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface ProfileViewController : UIViewController {
    IBOutlet UITableView *profileTable;
}

extern Profile *_Profile;

@property (nonatomic, retain) UITableView *profileTable;

@end
