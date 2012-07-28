//
//  DownloadMusicViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 3/22/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DownloadMusicViewController : UIViewController<NSURLConnectionDelegate> {
    IBOutlet UITableView *musicTable;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UILabel *status;
    
    NSMutableArray *musicArray;
    NSMutableData *received_data;
    

}

@property (nonatomic, retain) UITableView *musicTable;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UILabel *status;
@property (nonatomic, retain) NSMutableArray *musicArray;
@property (nonatomic, retain) NSMutableData *received_data;

@end
