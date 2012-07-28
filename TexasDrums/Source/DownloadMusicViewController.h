//
//  DownloadMusicViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 3/22/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TexasDrumsAPIConnection.h"

@protocol TexasDrumsAPIConnection;

@class Music;

@interface DownloadMusicViewController : UIViewController<TexasDrumsAPIConnection, UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *musicTable;
    NSMutableArray *musicArray;

}

@property (nonatomic, retain) UITableView *musicTable;
@property (nonatomic, retain) NSMutableArray *musicArray;

- (void)parseMusicData:(NSDictionary *)results;
- (Music *)createNewMusic:(NSDictionary *)item;

@end
