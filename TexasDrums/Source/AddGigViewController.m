//
//  AddGigViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 7/18/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "AddGigViewController.h"

@interface AddGigViewController ()

@end

@implementation AddGigViewController

@synthesize navigationBar, detailView;

@synthesize backgroundButton = backgroundButton_;
@synthesize name = name_;
@synthesize date = date_;
@synthesize dateButton = dateButton_;
@synthesize location = location_;
@synthesize description = description_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Add Gig"];
    [self.view addSubview:self.detailView];
    
    // Set properties.
    self.detailView.frame = CGRectMake(0, 44, 320, 411);
    self.detailView.contentSize = CGSizeMake(320, 553);
    self.name.textColor = [UIColor TexasDrumsGrayColor];
    self.name.font = [UIFont TexasDrumsFontOfSize:14];
    self.date.textColor = [UIColor TexasDrumsGrayColor];
    self.date.font = [UIFont TexasDrumsFontOfSize:14];
    self.location.textColor = [UIColor TexasDrumsGrayColor];
    self.location.font = [UIFont TexasDrumsFontOfSize:14];
    self.description.textColor = [UIColor TexasDrumsGrayColor];
    self.description.font = [UIFont TexasDrumsFontOfSize:14];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMMM d, yyyy' at 'h:mm a";
    NSString *current_date = [dateFormatter stringFromDate:[NSDate date]]; 
    self.date.text = current_date;
    [dateFormatter release];
    
    UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(removeModalView)] autorelease];
    self.navigationBar.leftBarButtonItem = cancelButton;
    
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

#pragma mark - UI Methods

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationBar.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont TexasDrumsBoldFontOfSize:20];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleView.textColor = [UIColor whiteColor]; 
        
        self.navigationBar.titleView = titleView;
        [titleView release];
    }
    titleView.text = title;
    [titleView sizeToFit];
}

- (IBAction)dateButtonPressed:(id)sender {
    
}

- (IBAction)backgroundButtonPressed:(id)sender {
    [self.name resignFirstResponder];
    [self.location resignFirstResponder];
    [self.description resignFirstResponder];
}

- (void)removeModalView {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITextField Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}


@end
