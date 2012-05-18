//
//  Profile.m
//  TexasDrums
//
//  Created by Corey Roberts on 8/9/11.
//  Copyright 2011 University of Texas at Austin. All rights reserved.
//

#import "Profile.h"

@implementation Profile

@synthesize firstname, lastname, username, password, section, years, status, sl, instructor, admin, phonenumber, email, birthday, valid, lastlogin, paid, alphabet_last, alphabet_first;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [firstname release];
    [lastname release];
    [username release];
    [password release];
    [section release];
    [years release];
    [status release];
    [email release];
    [phonenumber release];
    [birthday release];
    [alphabet_last release];
    [alphabet_first release];
    [lastlogin release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
