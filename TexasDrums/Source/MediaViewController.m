//
//  MediaViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "MediaViewController.h"
#import "AudioViewController.h"
#import "VideoViewController.h"
#import "PictureViewController.h"

@implementation MediaViewController

@synthesize mediaOptions;

#pragma mark - Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Media"];
    
    // Allocate things as necessary.
    mediaOptions = [[NSArray alloc] initWithObjects:@"Audio", @"Video", nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI Methods

- (IBAction)audioButtonPressed:(id)sender {
    AudioViewController *AVC = [[AudioViewController alloc] initWithNibName:@"AudioView" bundle:[NSBundle mainBundle]];
    
    [self.navigationController pushViewController:AVC animated:YES];
}

- (IBAction)videoButtonPressed:(id)sender {
    VideoViewController *VVC = [[VideoViewController alloc] initWithNibName:@"VideoView" bundle:[NSBundle mainBundle]];
    
    [self.navigationController pushViewController:VVC animated:YES];
}

@end
