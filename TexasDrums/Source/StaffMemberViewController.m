//
//  StaffMemberViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 4/20/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "StaffMemberViewController.h"
#import "TexasDrumsWebViewController.h"
#import "StaffMember.h"

#define DOMAIN_PATH (@"http://www.texasdrums.com/")

@interface StaffMemberViewController ()

@end

@implementation StaffMemberViewController

@synthesize member, picture, bio, scroll, loadBio; //, indicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [UILabel TexasDrumsNavigationBar];
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated {
    [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"Staff Member: %@ (StaffMemberView)", member.fullname] withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:member.fullname];
    
    self.loadBio = FALSE;
    self.picture.alpha = 0.0f;
    self.bio.alpha = 0.0f;
    //self.indicator.alpha = 1.0f;
    
    // Initialize and set properties for the picture, bio, and the scroller.
    [self initializePicture];
    [self initializeBio];
    [self initializeScroll];
    
    // After initialization, add the UIScrollView to the main view.
    [self.view addSubview:scroll];
}

- (void)initializePicture {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DOMAIN_PATH, member.image_url]];
    
    // Since the UIImageView is set first, set the inital coordinates to (0,0).
    picture = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)] autorelease];
    
    [self.picture setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Thumbnail.png"]];
    
    // Set UIImageView properties.
    self.picture.contentMode = UIViewContentModeScaleAspectFill;
    self.picture.clipsToBounds = YES;
}

- (void)initializeBio {
    
    // HTML
    NSString *header = [NSString stringWithString:@"<html><body link=#FF792A vlink=#CE792A alink=#FF792A><p style = 'font-family: Georgia; font-size: 12px; color: #999999; text-align: center;'>"];
    NSString *footer = [NSString stringWithFormat:@"</p><p style = 'font-family: Georgia; font-size: 14px; color: #999999; text-align: center;'><strong>Email <a href='mailto:%@'>%@</a></strong><br /></p></body></html>", member.email, member.first];
    NSString *HTMLString = [NSString stringWithFormat:@"%@%@%@", header, member.bio, footer];
   
    // Set the frame to start at (0, height of picture).
    bio = [[[UIWebView alloc] initWithFrame:CGRectMake(0, picture.frame.size.height, 320, 175)] autorelease];
    
    [self.bio loadHTMLString:HTMLString baseURL:nil];
    
    // Set UIWebView properties.
    self.bio.backgroundColor = [UIColor clearColor];
    self.bio.dataDetectorTypes = UIDataDetectorTypeLink;
    self.bio.opaque = NO;
    self.bio.scrollView.scrollEnabled = NO;
    self.bio.delegate = self;
}

- (void)initializeScroll {
    // Set UIScrollView's frame to be the UIView (not including space for the UINavigationBar or UITabBar) = (320, 367).
    scroll = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 375)] autorelease];
    
    // Set UIScrollView properties.
    self.scroll.backgroundColor = [UIColor clearColor];
    self.scroll.scrollEnabled = YES;
    
    // Add the UIImageView and UIWebView to the UIScrollView's view.
    [self.scroll addSubview:picture];    
    [self.scroll addSubview:bio];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIWebView Delegate Methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Use JavaScript to calculate the height of the 'document,' which is the WebView.
    CGFloat contentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] floatValue];
    
    // Adjust the WebView's frame accordingly, and set the content size of the UIScrollView to show all content.
    webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, contentHeight);
    self.scroll.contentSize = CGSizeMake(320, picture.frame.size.height+webView.frame.size.height);
    
    self.loadBio = TRUE;
    [UIView beginAnimations:@"webview" context:NULL];
    [UIView setAnimationDelay:1.0f];
    self.bio.alpha = 1.0f;
    self.picture.alpha = 1.0f;
    //self.indicator.alpha = 0.0f;
    [UIView commitAnimations];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType 
{
    if(!loadBio){
        return YES;
    }
    else {
        TDLog(@"%@", request);
        if([[[request URL] absoluteString] rangeOfString:@"mailto:"].location == NSNotFound){
            TexasDrumsWebViewController *TDWBC = [[[TexasDrumsWebViewController alloc] init] autorelease];
            TDWBC.url = request;
            [self.navigationController pushViewController:TDWBC animated:YES];
        }
        else{
            if([MFMailComposeViewController canSendMail]){
                MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
                mailVC.mailComposeDelegate = self;
                [mailVC setToRecipients:[NSArray arrayWithObject:member.email]];
                [mailVC setSubject:@"Question about Texas Drums"];
                [self presentModalViewController:mailVC animated:YES];
                [mailVC release];
            }
        }
        return NO;
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}

@end
