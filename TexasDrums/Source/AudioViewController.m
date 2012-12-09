//
//  AudioViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 3/9/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "AudioViewController.h"
#import "CJSONDeserializer.h"
#import "TexasDrumsTableViewCell.h"

@interface AudioViewController() {
    int currentTrack;
}

@property (nonatomic, assign) int currentTrack;

- (void)pausePlayer;
- (void)resumePlayer;
- (NSString *)grabFilenameWithIndex:(int)index;

@end

@implementation AudioViewController

@synthesize audioTable, currentTrack, pauseButton, playButton, audioPlayer, audioArray;

#pragma mark - Memory Management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [audioTable release], audioTable = nil;
    [pauseButton release], pauseButton = nil;
    [playButton release], playButton = nil;
    [audioPlayer release], audioPlayer = nil;
    [audioArray release], audioArray = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Audio"];

    // Set variables.
    self.pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pausePlayer)];
    self.playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(resumePlayer)];
    
    // Set properties.
    self.audioTable.alpha = 1.0f;
    self.audioTable.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.rightBarButtonItem = self.pauseButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.currentTrack = -1;
    
    // Allocate things as necessary.
#warning - move this to init.
    if(audioArray == nil){
        self.audioArray = [[NSMutableArray alloc] initWithObjects:@"Go Horns Go", @"Go, Go Horns", @"Texas Texas Yee Haw", @"Gourdhead", @"Tenor Intro", @"Defense", @"Push 'em Back", @"Hold 'em Horns, Hold 'em", @"D-D-D, Defense", @"Cheerleader", @"Buck Buck", @"Full Cadence Run", nil];
    }
    
    if(audioPlayer == nil){
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:nil error:nil];
        self.audioPlayer.delegate = self;
    }

}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if([audioPlayer isPlaying]){
        [audioPlayer stop];
        self.audioPlayer.delegate = nil;
        self.audioPlayer = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI Methods

- (void)pausePlayer {
    if([audioPlayer isPlaying]){
        [audioPlayer pause];
        self.navigationItem.rightBarButtonItem = self.playButton;
    }
}

- (void)resumePlayer {
    if(![audioPlayer isPlaying]){
        [audioPlayer play];
        self.navigationItem.rightBarButtonItem = self.pauseButton;
    }
}

#pragma mark - Data Methods

- (NSString *)grabFilenameWithIndex:(int)index {
    switch(index) {
        case 0:
            return @"GoHornsGo.mp3";
            break;
        case 1:
            return @"GoGoHorns.mp3";
            break;
        case 2:
            return @"TexasTexasYeeHaw.mp3";
            break;
        case 3:
            return @"Gourdhead.mp3";
            break;
        case 4:
            return @"TenorIntro.mp3";
            break;
        case 5:
            return @"Defense.mp3";
            break;
        case 6:
            return @"PushEmBack.mp3";
            break;
        case 7:
            return @"HoldEmHornsHoldEm.mp3";
            break;
        case 8:
            return @"D-D-DDefense.mp3";
            break;
        case 9:
            return @"Cheerleader.mp3";
            break;
        case 10:
            return @"BuckBuck.mp3";
            break;
        case 11:
            return @"FullCadenceRun.mp3";
            break;
        default:
            break;
    }
    
    return nil;
}

#pragma mark - UITableView Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [audioArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    TexasDrumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TexasDrumsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];

        cell.textLabel.font = [UIFont TexasDrumsBoldFontOfSize:18];
    }
    
    if(currentTrack == indexPath.row) {
        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"note.png"]] autorelease];
        cell.textLabel.textColor = [UIColor TexasDrumsOrangeColor];
    }
    else {
        cell.accessoryView = nil;
        cell.textLabel.textColor = [UIColor TexasDrumsGrayColor];
    }
    
    cell.textLabel.text = [audioArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.audioTable deselectRowAtIndexPath:indexPath animated:YES];
    
    // If user taps the same cell, just stop the player and restart.
    if(self.currentTrack == indexPath.row){
        if([audioPlayer isPlaying]){
            [audioPlayer stop];
            [audioPlayer setCurrentTime:0.0f];
        }
        
        [audioPlayer play];
        return;
    }
    
    // Set the old cell properties.
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:self.currentTrack inSection:0];
    UITableViewCell *cell = [self.audioTable cellForRowAtIndexPath:oldIndexPath];
    cell.accessoryView = nil;
    cell.textLabel.textColor = [UIColor TexasDrumsGrayColor];
    
    self.currentTrack = indexPath.row;
    self.navigationItem.rightBarButtonItem = self.pauseButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    [audioPlayer stop];
    [audioPlayer release];
    self.audioPlayer = nil;
    
    // Fetch the file directory path.
    NSString *filename = [self grabFilenameWithIndex:indexPath.row];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename]];
    TDLog(@"%@", url);
    
    if(audioPlayer == nil){
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.audioPlayer.delegate = self;
    }
    
    audioPlayer.numberOfLoops = 0;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    
    // Set the new cell properties.
    cell = [self.audioTable cellForRowAtIndexPath:indexPath];
    cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"note.png"]] autorelease];;
    cell.textLabel.textColor = [UIColor TexasDrumsOrangeColor];
}

#pragma mark - AVAudioPlayer Delegate Methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    self.navigationItem.rightBarButtonItem = self.playButton;
    [audioPlayer setCurrentTime:0.0f];

    NSIndexPath *indexPath = [self.audioTable indexPathForSelectedRow];
    if(indexPath) {
        [self.audioTable deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
