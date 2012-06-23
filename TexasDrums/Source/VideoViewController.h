//
//  VideoViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 3/9/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TexasDrumsAPIConnection.h"

@interface VideoViewController : UIViewController<TexasDrumsAPIConnection, UITableViewDelegate> {
    IBOutlet UITableView *videoTable;
    NSMutableArray *videoArray;
    NSMutableArray *yearArray;
}

@property (nonatomic, retain) UITableView *videoTable;
@property (nonatomic, retain) NSMutableArray *videoArray;
@property (nonatomic, retain) NSMutableArray *yearArray;

@end
