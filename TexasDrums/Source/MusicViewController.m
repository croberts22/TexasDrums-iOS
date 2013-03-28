//
//  MusicViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 4/6/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "MusicViewController.h"

@interface MusicViewController ()

@end

@implementation MusicViewController

#define kPDFPageBounds CGRectMake(0, 0, 8.5 * 72, 11 * 72)

@synthesize webView, url, filename, printController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:self.filename];
    
    //add a 'print' button for now.
    UIBarButtonItem *print = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(print_PDF)];
    
    self.navigationItem.rightBarButtonItem = print;
    
    //load url into web view
    NSURL *pdf_url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:pdf_url];
    [webView loadRequest:request];
    
    Class printControllerClass = NSClassFromString(@"UIPrintInteractionController");
    if (printControllerClass) {
        printController = [printControllerClass sharedPrintController];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)print_PDF {
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
        if (!completed && error) TDLog(@"Print error: %@", error);
    };
    
    NSData *pdfData = [self generatePDFDataForPrinting];
    printController.printingItem = pdfData;
    [printController presentAnimated:YES completionHandler:completionHandler];
}

- (NSData *)generatePDFDataForPrinting {
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, kPDFPageBounds, nil);
    UIGraphicsBeginPDFPage();
    //CGContextRef ctx = UIGraphicsGetCurrentContext();
    //[self drawStuffInContext:ctx];  // Method also usable from drawRect:.
    UIGraphicsEndPDFContext();
    return pdfData;   
}

@end
