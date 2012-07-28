//
//  AboutUsViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 1/10/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "AboutUsViewController.h"
#import "CJSONDeserializer.h"

@implementation AboutUsViewController

@synthesize image, info, large_indicator, indicator, received_data, status;

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
        titleView = [UILabel TexasDrumsNavigationBar];
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated {
    [[GANTracker sharedTracker] trackPageview:@"About Us (AboutUsView)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"About Us"];
    
    self.image.alpha = 0.0f;
    self.info.alpha = 0.0f;
    self.indicator.alpha = 1.0f;
    self.large_indicator.alpha = 1.0f;
    self.status.alpha = 1.0f;
    self.status.text = @"Loading...";
    
    [self startIndicators];
    [self fetchAbout];
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
     
- (void)startIndicators {
    [large_indicator startAnimating];
    [indicator startAnimating];
}

- (void)stopLargeIndicator {
    [UIView beginAnimations:@"removeLargeIndicator" context:NULL];
    [UIView setAnimationDelay:0.5f];
    self.large_indicator.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)stopIndicator {
    [UIView beginAnimations:@"removeIndicator" context:NULL];
    [UIView setAnimationDelay:0.5f];
    self.indicator.alpha = 0.0f;
    [UIView commitAnimations];    
}

- (void)fetchAbout {
    [self startConnection];
}

- (void)startConnection {
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@", TEXAS_DRUMS_API_ABOUT, TEXAS_DRUMS_API_KEY];
    TDLog(@"%@", API_Call);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLConnection *urlconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if(urlconnection) {
        received_data = [[NSMutableData data] retain];
    }
}

- (void)parseAboutData:(NSDictionary *)results {
    for(NSDictionary *item in results){
        
        //set image
        NSString *link = [item objectForKey:@"picture"];
        [self loadImage:link];
        
        //set text
        NSString *text = [item objectForKey:@"information"];
        [self performSelectorOnMainThread:@selector(displayText:) withObject:text waitUntilDone:NO];
    }
}

- (void)loadImage:(NSString *)link {
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:link]];
    UIImage* picture = [[[UIImage alloc] initWithData:imageData] autorelease];
    [imageData release];
    [self performSelectorOnMainThread:@selector(displayImage:) withObject:picture waitUntilDone:NO];
}

- (void)displayImage:(UIImage *)picture {
    [self stopLargeIndicator];
    self.image.image = picture;
    [UIView beginAnimations:@"showImage" context:NULL];
    [UIView setAnimationDelay:0.5f];
    self.image.alpha = 1.0f;
    self.status.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)displayText:(NSString *)text {
    [self stopIndicator];
    self.info.text = text;
    [UIView beginAnimations:@"showText" context:NULL];
    [UIView setAnimationDelay:0.5f];
    self.info.alpha = 1.0f;
    [UIView commitAnimations];
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    [received_data setLength:0];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to received_data.
    [received_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    [received_data release];
    
    // inform the user
    TDLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" 
                                                    message:[error localizedDescription] 
                                                   delegate:self 
                                          cancelButtonTitle:@":( Okay" 
                                          otherButtonTitles:nil, nil];
    
    [alert show];
    [alert release];
    
    self.status.text = @"Nothing was found. Please try again later.";
    [indicator stopAnimating];
    [large_indicator stopAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:received_data error:&error];
    
    [self parseAboutData:results];
    TDLog(@"Succeeded! Received %d bytes of data", [received_data length]);
    
    // release the connection, and the data object
    [connection release];
    [received_data release];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
