//
//  NewsPostView.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/27/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "NewsPostView.h"
#import "News.h"
#import "TexasDrumsWebViewController.h"

@interface NewsPostView()

- (void)createHeader;
- (NSString *)createPost;

@end

@implementation NewsPostView

@synthesize webView, titleOfPost, dateAndAuthor, content, post, isMemberPost, loadPost;

#pragma mark - Memory Management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.titleOfPost.text = @"";
        self.dateAndAuthor.text = @"";
        self.content = @"";
        self.post = nil;
        self.isMemberPost = NO;
        self.loadPost = NO;
    }
    return self;
}

- (void)dealloc {
    self.webView.delegate = nil;
    [webView release], webView = nil;
    [titleOfPost release], titleOfPost = nil;
    [dateAndAuthor release], dateAndAuthor = nil;
    [post release], post = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Set properties.
    self.webView.delegate = self;
    self.webView.alpha = 0.0f;
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];    
    
    if(isMemberPost){
        self.titleOfPost.textColor = [UIColor TexasDrumsOrangeColor];
    }
    
    // Create header.
    [self createHeader];
    
    // Create body.
    NSString *HTMLString = [self createPost];
    
    // Load web view.
    [self.webView loadHTMLString:HTMLString baseURL:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Data Methods

- (void)createHeader {
    self.titleOfPost.text = post.titleOfPost;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:post.timestamp];
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    [format setDateFormat:@"MMMM d, yyyy 'at' h:m a"];
    
    NSString *dateString = [format stringFromDate:date];
    
    self.dateAndAuthor.text = [NSString stringWithFormat:@"Posted by %@ on %@", post.author, dateString];
}

- (NSString *)createPost {
    NSString *header = @"<html><body link=#FF792A vlink=#CE792A alink=#FF792A><p style = 'font-family: Georgia; font-size: 14px; background-color: #000000; color: #999999'><br />";
    NSString *footer = @"</p><br /></body></html>";
    
    return [NSString stringWithFormat:@"%@%@%@", header, post.post, footer];
}

#pragma mark - UIWebView Delegate Methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.loadPost = TRUE;
    [UIView beginAnimations:@"webview" context:NULL];
    [UIView setAnimationDuration:0.5f];
    self.webView.alpha = 1.0f;
    self.titleOfPost.alpha = 1.0f;
    self.dateAndAuthor.alpha = 1.0f;
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

@end
