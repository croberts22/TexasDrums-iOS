//
//  AudioViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 3/9/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioViewController : TexasDrumsViewController<AVAudioPlayerDelegate> {
    IBOutlet UITableView *audioTable;
    UIBarButtonItem *pauseButton;
    UIBarButtonItem *playButton;
    AVAudioPlayer *audioPlayer;
    NSMutableArray *audioArray;
}

@property (nonatomic, retain) UITableView *audioTable;
@property (nonatomic, retain) UIBarButtonItem *pauseButton;
@property (nonatomic, retain) UIBarButtonItem *playButton;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) NSMutableArray *audioArray;

@end
