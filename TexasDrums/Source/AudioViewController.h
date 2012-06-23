//
//  AudioViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 3/9/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioViewController : UIViewController<AVAudioPlayerDelegate> {
    IBOutlet UITableView *audioTable;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UILabel *status;
    IBOutlet UIProgressView *statusBar;
    
    UITableViewCell *currentCell;
    UIBarButtonItem *pauseButton;
    UIBarButtonItem *playButton;
    
    AVAudioPlayer *audioPlayer;
    
    NSMutableArray *audioArray;
    NSMutableArray *yearArray;
    
    BOOL mediaFinishedLoading;
}

@property (nonatomic, retain) UITableView *audioTable;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UILabel *status;
@property (nonatomic, retain) UIProgressView *statusBar;
@property (nonatomic, retain) UITableViewCell *currentCell;
@property (nonatomic, retain) UIBarButtonItem *pauseButton;
@property (nonatomic, retain) UIBarButtonItem *playButton;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) NSMutableArray *audioArray;
@property (nonatomic, retain) NSMutableArray *yearArray;
@property (nonatomic, assign) BOOL mediaFinishedLoading;

@end
