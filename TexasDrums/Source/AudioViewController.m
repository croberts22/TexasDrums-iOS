//
//  AudioViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 3/9/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "AudioViewController.h"
#import "GANTracker.h"
#import "Audio.h"
#import "Common.h"
#import "CJSONDeserializer.h"
#import "TexasDrumsTableViewCell.h"

#import "UIFont+TexasDrums.h"

#define CELL_CONTENT_WIDTH (320.0f)
#define CELL_CONTENT_MARGIN (10.0f)
#define _HEADER_HEIGHT_ (40)
#define FONT_SIZE (16.0f)

@implementation AudioViewController

@synthesize audioArray, audioTable, audioPlayer, mediaFinishedLoading, currentCell, pauseButton, playButton, indicator, status, yearArray, statusBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    // Google Analytics.
    [[GANTracker sharedTracker] trackPageview:@"Audio (AudioView)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Audio"];

    // Set variables.
    self.pauseButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pausePlayer)] autorelease];
    self.playButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(resumePlayer)] autorelease];
    
    // Set properties.
    self.audioTable.alpha = 1.0f;
    self.audioTable.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.rightBarButtonItem = self.pauseButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // Allocate things as necessary.
    if(audioArray == nil){
        self.audioArray = [[[NSMutableArray alloc] initWithObjects:@"Go Horns Go", @"Go, Go Horns", @"Texas Texas Yee Haw", @"Gourdhead", @"Tenor Intro", @"Defense", @"Push 'em Back", @"Hold 'em Horns, Hold 'em", @"D-D-D, Defense", @"Cheerleader", @"Buck Buck", @"Full Cadence Run", nil] autorelease];
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    if([audioPlayer isPlaying]){
        [audioPlayer stop];
        [audioPlayer release];
        self.audioPlayer = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI Methods

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont fontWithName:@"Georgia-Bold" size:20];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleView.textColor = [UIColor whiteColor]; 
        
        self.navigationItem.titleView = titleView;
        [titleView release];
    }
    titleView.text = title;
    [titleView sizeToFit];
}

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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [audioArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TexasDrumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TexasDrumsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.font = [UIFont TexasDrumsBoldFontOfSize:18];
    
    cell.textLabel.text = [audioArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If user taps the same cell, just stop the player and restart.
    if(self.currentCell == [tableView cellForRowAtIndexPath:indexPath]){
        if([audioPlayer isPlaying]){
            [audioPlayer stop];
            [audioPlayer setCurrentTime:0.0f];
        }
        
        [audioPlayer play];
        return;
    }
    
    self.navigationItem.rightBarButtonItem = self.pauseButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    [audioPlayer stop];
    [audioPlayer release];
    self.audioPlayer = nil;
    
    // Fetch the file directory path.
    NSString *filename = [self grabFilenameWithIndex:indexPath.row];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename]];
    NSLog(@"%@", url);
    
    if(audioPlayer == nil){
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.audioPlayer.delegate = self;
    }
    
    audioPlayer.numberOfLoops = 0;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}

#pragma mark - AVAudioPlayer Delegate Methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.navigationItem.rightBarButtonItem = self.playButton;
    [audioPlayer setCurrentTime:0.0f];
}

@end
