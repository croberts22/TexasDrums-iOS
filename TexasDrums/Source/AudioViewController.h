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
    int currentTrack;
    UIBarButtonItem *pauseButton;
    UIBarButtonItem *playButton;
    AVAudioPlayer *audioPlayer;
    NSMutableArray *audioArray;
}

@property (nonatomic, retain) UITableView *audioTable;
@property (nonatomic, assign) int currentTrack;
@property (nonatomic, retain) UIBarButtonItem *pauseButton;
@property (nonatomic, retain) UIBarButtonItem *playButton;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) NSMutableArray *audioArray;

- (void)pausePlayer;
- (void)resumePlayer;
- (NSString *)grabFilenameWithIndex:(int)index;

@end
