//
//  AboutThisAppViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 1/13/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "AboutThisAppViewController.h"

@implementation AboutThisAppViewController

@synthesize aboutInfo;

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
    [aboutInfo release], aboutInfo = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"About This App"];
    
    NSString *texasDrums = @"Texas Drums for iPhone made by Corey Roberts.";
    NSString *splashScreen = @"Texas Drums logo designed by Richard Fish.";
    NSString *moreInfo = @"For more info, check out http://www.texasdrums.com";
    NSString *librariesUsed = @"Special thanks to the following:";
    NSString *crittercism = @"- Crittercism and the Crittercism SDK";
    NSString *asi = @"- ASI's ASIHTTPRequest library";
    NSString *sdimage = @"- Oliver Poitrey's SDWebImage library";
    NSString *google = @"- Google and the Google Analytics SDK";
    NSString *touchJSON = @"- Jonathan Wight's Cocoa/TouchJSON library";
    NSString *regexkit = @"- John Engelhart's RegexKit library";
    NSString *family = @"- The entire Texas Drums, Longhorn Band, and University of Texas at Austin community for all of their support! :)";
    NSString *legal = @"The University of Texas at Austin Longhorn logo is property of The University of Texas at Austin.";
    
    NSString *libraryString = [NSString stringWithFormat:@"%@\n\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n\n%@\n", librariesUsed, crittercism, asi, sdimage, google, touchJSON, regexkit, family, legal];
    
    self.aboutInfo.text = @"Texas Drums for iPhone made by Corey Roberts. \nSplash screen designed by Richard Fish.\n\n";
    
    self.aboutInfo.text = [NSString stringWithFormat:@"%@\n%@\n\n%@\n\n%@", texasDrums, splashScreen, moreInfo, libraryString];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
