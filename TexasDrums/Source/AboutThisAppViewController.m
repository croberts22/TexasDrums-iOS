//
//  AboutThisAppViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 1/13/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "AboutThisAppViewController.h"
#import "GANTracker.h"

@implementation AboutThisAppViewController

@synthesize aboutInfo;

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

- (void)viewWillAppear:(BOOL)animated {
    [[GANTracker sharedTracker] trackPageview:@"About App (AboutThisAppView)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"About This App"];
    NSString *programmers = @"Corey Roberts";
    NSString *splash_design = @"Richard Fish";
    NSString *website = @"http://www.texasdrums.com";
    
    self.aboutInfo.text = [NSString stringWithFormat:@"Texas Drums for iPhone made by %@. \nSplash screen designed by %@. \n\n\nFor more info, check out %@", programmers, splash_design, website];
    
    //aboutInfo.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //aboutInfo.layer.shadowOffset = CGSizeMake(0, -2.0);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
