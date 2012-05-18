//
//  SingleRosterViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/28/11.
//  Copyright 2011 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SingleRosterViewController : UIViewController {
    NSString *year;
    NSArray *snares;
    NSArray *tenors;
    NSArray *basses;
    NSArray *cymbals;
    IBOutlet UITableView *singleRosterTable;
}

@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSArray *snares;
@property (nonatomic, retain) NSArray *tenors;
@property (nonatomic, retain) NSArray *basses;
@property (nonatomic, retain) NSArray *cymbals;
@property (nonatomic, retain) UITableView *singleRosterTable;

@end
