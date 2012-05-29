//
//  VideoViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 3/9/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "CJSONDeserializer.h"

@interface VideoViewController : UIViewController<NSURLConnectionDelegate, UITableViewDelegate> {
    IBOutlet UITableView *videoTable;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UILabel *status;
    
    NSMutableArray *videoArray;
    NSMutableArray *yearArray;
    NSMutableData *received_data;
}

@property (nonatomic, retain) UITableView *videoTable;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UILabel *status;
@property (nonatomic, retain) NSMutableArray *videoArray;
@property (nonatomic, retain) NSMutableArray *yearArray;
@property (nonatomic, retain) NSMutableData *received_data;

@end
