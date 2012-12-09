//
//  SingleRosterViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/28/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Roster;

@interface SingleRosterViewController : TexasDrumsViewController {
    NSString *year;
    Roster *roster;
    IBOutlet UITableView *singleRosterTable;
}

@property (nonatomic, copy) NSString *year;
@property (nonatomic, retain) Roster *roster;
@property (nonatomic, retain) UITableView *singleRosterTable;

@end
