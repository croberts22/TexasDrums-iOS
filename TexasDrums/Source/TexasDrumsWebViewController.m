//
//  TexasDrumsWebViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 4/16/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "TexasDrumsWebViewController.h"
#import "GANTracker.h"

@interface TexasDrumsWebViewController ()

@end

@implementation TexasDrumsWebViewController

@synthesize browser, url, the_title, indicator, toolbarItems, toolbar;

@synthesize fixedSpaceLeft, fixedSpaceRight, fixedSpaceMiddle, backButton, nextButton, refreshButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont fontWithName:@"Georgia-Bold" size:20];
        titleView.minimumFontSize = 10.0f;
        titleView.adjustsFontSizeToFitWidth = YES;
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleView.textColor = [UIColor whiteColor]; 
        
        self.navigationItem.titleView = titleView;
        [titleView release];
    }
    titleView.text = title;
    [titleView sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated {
    [[GANTracker sharedTracker] trackPageview:@"News Browser (NewsWebView)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.indicator = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)] autorelease];
    
    [self.indicator sizeToFit];
    [self.indicator setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    
    if(the_title != nil){
        [self setTitle:the_title];
    }
    if(toolbarItems == nil){
        toolbarItems = [[NSMutableArray alloc] init];
    }
    
    [toolbarItems addObject:fixedSpaceLeft];
    [toolbarItems addObject:backButton];
    [toolbarItems addObject:fixedSpaceMiddle];
    [toolbarItems addObject:nextButton];
    [toolbarItems addObject:fixedSpaceRight];
    [toolbarItems addObject:refreshButton];
    
    self.browser.scalesPageToFit = YES;
    self.backButton.enabled = NO;
    self.nextButton.enabled = NO;
    [self.browser loadRequest:url];
    NSLog(@"%@", url.URL);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    if([self.browser isLoading]){
        [self.browser stopLoading];    
    }
    self.browser.delegate = nil;        
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight ||
            interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (IBAction)refreshButtonPressed:(id)sender {
    [self hideRefreshButton];
    [self.browser reload];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.browser goBack];
}

- (IBAction)nextButtonPressed:(id)sender {
    [self.browser goForward];
}

- (void)hideRefreshButton {
    
    UIBarButtonItem *loading = [[[UIBarButtonItem alloc] initWithCustomView:indicator] autorelease];
    
    [indicator startAnimating];
    [toolbarItems replaceObjectAtIndex:[toolbarItems count] - 1 withObject:loading];
    toolbar.items = toolbarItems;
}

- (void)showRefreshButton {
    [indicator stopAnimating];
    [toolbarItems replaceObjectAtIndex:[toolbarItems count] - 1 withObject:refreshButton];
    toolbar.items = toolbarItems;
}

- (void)checkBackButton {
    if(!self.browser.canGoBack) {
        self.backButton.enabled = NO;
    }
    else {
        self.backButton.enabled = YES;
    } 
}

- (void)checkNextButton {
    if(!self.browser.canGoForward) {
        self.nextButton.enabled = NO;
    }
    else {
        self.nextButton.enabled = YES;
    }
}

# pragma mark - UIWebView delegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self hideRefreshButton];
    [self checkBackButton];
    [self checkNextButton];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self showRefreshButton];
    [self checkBackButton];
    [self checkNextButton];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self showRefreshButton];
    [self checkBackButton];
    [self checkNextButton];
}

@end
