//
//  AboutUsViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 1/10/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "AboutUsViewController.h"
#import "CJSONDeserializer.h"
#import "TexasDrumsGetAbout.h"

@interface AboutUsViewController()

- (void)displayText:(NSString *)text;
- (void)parseAboutData:(NSDictionary *)results;

@end

@implementation AboutUsViewController

@synthesize image, info;

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

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"About Us"];
    
    self.image.alpha = 0.0f;
    self.info.alpha = 0.0f;
    
    [self connect];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI Methods

- (void)refreshPressed {
    // Fetch roster from the server.
    [self connect];
}

- (void)hideRefreshButton {
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)dismissWithSuccess {
    self.navigationItem.rightBarButtonItem = nil;
    [SVProgressHUD dismiss];
}

- (void)dismissWithError {
    //self.navigationItem.rightBarButtonItem = refresh;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [SVProgressHUD showErrorWithStatus:@"Could not fetch data."];
}

- (void)displayText:(NSString *)text {
    self.info.text = text;
    [UIView animateWithDuration:0.5f animations:^{
        self.info.alpha = 1.0f;
    }];
}

#pragma mark - Data Methods

- (void)connect {
    [self hideRefreshButton];
    [SVProgressHUD showWithStatus:@"Loading..."];
    TexasDrumsGetAbout *get = [[TexasDrumsGetAbout alloc] init];
    get.delegate = self;
    [get startRequest];
}

- (void)parseAboutData:(NSDictionary *)results {
    
    for(NSDictionary *item in results){    
        // Set image.
        NSString *link = [item objectForKey:@"picture"];
        [self.image setImageWithURL:[NSURL URLWithString:link] success:^(UIImage *success){
            if(success) {
                [UIView animateWithDuration:0.5f animations:^{
                    self.image.alpha = 1.0f;
                }];
            }
        } failure:^(NSError *error){}];
        
        // Set text.
        NSString *text = [item objectForKey:@"information"];
        [self displayText:text];
    }
}

#pragma mark - TexasDrumsRequestDelegate Methods

- (void)request:(TexasDrumsRequest *)request receivedData:(id)data {
    TDLog(@"About request succeeded.");
    
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:data error:&error];
    
    if([results count] > 0){
        // Check if the response is just a dictionary value of one.
        // This implies that the key value pair follows the format:
        // status -> 'message'
        // We use respondsToSelector since the API returns a dictionary
        // of length one for any status messages, but an array of
        // dictionary responses for valid data.
        // CJSONDeserializer interprets actual data as NSArrays.
        if([results respondsToSelector:@selector(objectForKey:)] ){
            if([[results objectForKey:@"status"] isEqualToString:_403_UNKNOWN_ERROR]) {
                TDLog(@"No about information found. Request returned: %@", [results objectForKey:@"status"]);
                [self dismissWithSuccess];
                return;
            }
        }
        
        TDLog(@"New about information found. Parsing..");
        // Deserialize JSON results and parse them into Music objects.
        [self parseAboutData:results];
    }
    
    [self dismissWithSuccess];
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    TDLog(@"Request error: %@", error);
    
    // Show refresh button and error message.
    [self dismissWithError];
}


@end
