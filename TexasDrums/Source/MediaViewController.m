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

- (void)dealloc {
    [mediaOptions release], mediaOptions = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GANTracker sharedTracker] trackPageview:@"Media (MediaView)" withError:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Media"];
    
    // Allocate things as necessary.
    mediaOptions = [[NSArray alloc] initWithObjects:@"Audio", @"Video", nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI Methods

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [UILabel TexasDrumsNavigationBar];
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}

- (IBAction)audioButtonPressed:(id)sender {
    AudioViewController *AVC = [[AudioViewController alloc] initWithNibName:@"AudioView" bundle:[NSBundle mainBundle]];
    
    [self.navigationController pushViewController:AVC animated:YES];
    
    [AVC release];
}

- (IBAction)videoButtonPressed:(id)sender {
    VideoViewController *VVC = [[VideoViewController alloc] initWithNibName:@"VideoView" bundle:[NSBundle mainBundle]];
    
    [self.navigationController pushViewController:VVC animated:YES];
    
    [VVC release];
}

@end
