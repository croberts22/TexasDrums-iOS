//
//  NewsPostView.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/27/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "NewsPostView.h"
#import "TexasDrumsWebViewController.h"
#import "GANTracker.h"


@implementation NewsPostView

@synthesize webView, titleOfPost, dateAndAuthor, content, post, indicator, isMemberPost, loadPost;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [post release];
    [content release];
    [titleOfPost release];
    [dateAndAuthor release];
    [webView release];
    [indicator release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [[GANTracker sharedTracker] trackPageview:@"News Post (NewsPost)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
    
    NSString *header = [NSString stringWithString:@"<html><body link=#FF792A vlink=#CE792A alink=#FF792A><p style = 'font-family: Georgia; font-size: 14px; background-color: #000000; color: #999999'><br />"];
    NSString *footer = [NSString stringWithString:@"</p><br /></body></html>"];
    NSString *HTMLString = [NSString stringWithFormat:@"%@%@%@", header, post.post, footer];
    [self.webView loadHTMLString:HTMLString baseURL:nil];
    
    //for black background on webview
    //make everything hidden; once everything is loaded, load animation for everything on delegate method
    self.indicator.alpha = 1.0f;
    self.webView.alpha = 0.0f;
    self.titleOfPost.alpha = 0.0f;
    self.dateAndAuthor.alpha = 0.0f;
    if(isMemberPost){
        self.titleOfPost.textColor = [UIColor orangeColor];
    }
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    
    [self.indicator performSelectorInBackground:@selector(startAnimating) withObject:nil];

    self.titleOfPost.text = post.titleOfPost;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:post.timestamp];
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [format stringFromDate:date];
    self.dateAndAuthor.text = [NSString stringWithFormat:@"Posted by %@ on %@", post.author, dateString];
}

#pragma mark - UIWebView Delegate Methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.loadPost = TRUE;
    [UIView beginAnimations:@"webview" context:NULL];
    [UIView setAnimationDelay:1.0f];
    self.webView.alpha = 1.0f;
    self.titleOfPost.alpha = 1.0f;
    self.dateAndAuthor.alpha = 1.0f;
    self.indicator.alpha = 0.0f;
    [UIView commitAnimations];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType 
{
    if(!loadPost){
        return YES;
    }
    else {
        TexasDrumsWebViewController *TDWBC = [[[TexasDrumsWebViewController alloc] init] autorelease];
        TDWBC.url = request;
        [self.navigationController pushViewController:TDWBC animated:YES];
        return NO;
    }
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
