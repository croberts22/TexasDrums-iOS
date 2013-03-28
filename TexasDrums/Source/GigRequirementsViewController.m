//
//  GigRequirementsViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 8/4/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "GigRequirementsViewController.h"

@interface GigRequirementsViewController ()

@end

@implementation GigRequirementsViewController

@synthesize peopleRequired, snares, tenors, basses, cymbals, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.snares.text = [peopleRequired objectAtIndex:0];
    self.tenors.text = [peopleRequired objectAtIndex:1];
    self.basses.text = [peopleRequired objectAtIndex:2];
    self.cymbals.text = [peopleRequired objectAtIndex:3];
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

- (IBAction)doneButtonPressed:(id)sender {
    if([self.delegate respondsToSelector:@selector(gigRequirementsSelected:)]) {
        NSArray *requirements = [NSArray arrayWithObjects:snares.text, tenors.text, basses.text, cymbals.text, nil];
        [self.delegate gigRequirementsSelected:requirements];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
