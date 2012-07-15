//
//  ViewGigsViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 7/14/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TexasDrumsAPIConnection.h"

@interface ViewGigsViewController : UIViewController {
    IBOutlet UITableView *gigsTable;
    NSMutableArray *gigs;
}

@property (nonatomic, retain) UITableView *gigsTable;
@property (nonatomic, retain) NSMutableArray *gigs;

@end
