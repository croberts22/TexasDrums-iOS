//
//  AddGigViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 7/18/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "AddGigViewController.h"
#import "DateViewController.h"
#import "GigRequirementsViewController.h"
#import "MemberListViewController.h"

@interface AddGigViewController ()

@property (nonatomic, assign) CGPoint offset;

@end

@implementation AddGigViewController

@synthesize detailView, offset;

@synthesize backgroundButton = backgroundButton_;
@synthesize name = name_;
@synthesize date = date_;
@synthesize dateButton = dateButton_;
@synthesize peopleButton = peopleButton_;
@synthesize peopleRequired = peopleRequired_;
@synthesize location = location_;
@synthesize description = description_;
@synthesize currentSelection = currentSelection_;
@synthesize dateViewController = dateViewController_;

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
    self.detailView.frame = CGRectMake(0, 0, 320, 414);
    self.detailView.contentSize = CGSizeMake(320, 631);
    self.name.textColor = [UIColor TexasDrumsGrayColor];
    self.name.font = [UIFont TexasDrumsFontOfSize:14];
    self.date.textColor = [UIColor TexasDrumsGrayColor];
    self.date.font = [UIFont TexasDrumsFontOfSize:14];
    self.location.textColor = [UIColor TexasDrumsGrayColor];
    self.location.font = [UIFont TexasDrumsFontOfSize:14];
    self.description.textColor = [UIColor TexasDrumsGrayColor];
    self.description.font = [UIFont TexasDrumsFontOfSize:14];
    self.peopleRequired.textColor = [UIColor TexasDrumsGrayColor];
    self.peopleRequired.font = [UIFont TexasDrumsItalicFontOfSize:14];
    self.peopleRequired.text = NSLocalizedString(@"tap to edit", nil);
    self.peopleRequired.textAlignment = UITextAlignmentLeft;
    self.currentSelection = [[[NSArray alloc] initWithObjects:@"3", @"2", @"2", @"3", nil] autorelease];
    
    self.dateViewController = [[[DateViewController alloc] initWithNibName:@"DateViewController" bundle:[NSBundle mainBundle]] autorelease];
    self.dateViewController.view.frame = CGRectMake(0, self.view.frame.size.height, self.dateViewController.view.frame.size.width, self.dateViewController.view.frame.size.height);
    self.dateViewController.currentDate = [NSDate date];
    self.dateViewController.datePicker.date = [NSDate date];
    [self.view addSubview:self.dateViewController.view];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMMM d, yyyy' at 'h:mm a";
    NSString *current_date = [dateFormatter stringFromDate:[NSDate date]]; 
    self.date.text = current_date;
    [dateFormatter release];
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
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [UILabel TexasDrumsNavigationBar];
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}

- (IBAction)dateButtonPressed:(id)sender {
    [self removeKeyboards];
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
        self.dateViewController.view.frame = CGRectMake(0, self.view.frame.size.height-self.dateViewController.view.frame.size.height, self.dateViewController.view.frame.size.width, self.dateViewController.view.frame.size.height);
    }
                     completion:^(BOOL completed){}];
}

- (IBAction)peopleButtonPressed:(id)sender {
    GigRequirementsViewController *GRVC = [[[GigRequirementsViewController alloc] initWithNibName:@"GigRequirementsViewController" bundle:[NSBundle mainBundle]] autorelease];
    GRVC.delegate = self;
    GRVC.peopleRequired = self.currentSelection;
    
    [self.navigationController pushViewController:GRVC animated:YES];
}

- (IBAction)chooseMemberSelected:(id)sender {
    MemberListViewController *MLVC = [[[MemberListViewController alloc] initWithNibName:@"MemberListViewController" bundle:[NSBundle mainBundle]] autorelease];
    [self.navigationController pushViewController:MLVC animated:YES];
}

- (void)removeDatePicker {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMMM d, yyyy' at 'h:mm a";
    NSString *current_date = [dateFormatter stringFromDate:self.dateViewController.datePicker.date];
    self.date.text = current_date;
    [dateFormatter release];
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.dateViewController.view.frame = CGRectMake(0,
                                                                         self.view.frame.size.height,
                                                                         self.dateViewController.view.frame.size.width,
                                                                         self.dateViewController.view.frame.size.height);
                     }
                     completion:^(BOOL completed){}];
}

- (IBAction)backgroundButtonPressed:(id)sender {
    [self removeDatePicker];
    [self removeKeyboards];
}

- (void)removeKeyboards {
    [self.name resignFirstResponder];
    [self.location resignFirstResponder];
    [self.description resignFirstResponder];
    [self.detailView setContentOffset:offset animated:YES];
}

#pragma mark - UITextField Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self removeDatePicker];
    offset = self.detailView.contentOffset;
    CGRect rect = [textField convertRect:[textField bounds] toView:self.detailView];
    CGPoint point = rect.origin;
    point.x = 0;
    point.y -= 60;
    [self.detailView setContentOffset:point animated:YES];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.detailView setContentOffset:offset animated:YES];
    
    return YES;
}

#pragma mark - UITextView Delegate Methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    offset = self.detailView.contentOffset;
    CGRect rect = [description_ convertRect:[self.description bounds] toView:self.detailView];
    CGPoint point = rect.origin;
    point.x = 0;
    point.y -= 60;
    [self.detailView setContentOffset:point animated:YES];
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    [self.detailView setContentOffset:offset animated:YES];
    return YES;
}

#pragma mark - GigRequirementsViewController Delegate Methods

- (void)gigRequirementsSelected:(NSArray *)selection {
    self.currentSelection = selection;
    self.peopleRequired.textAlignment = UITextAlignmentCenter;
    self.peopleRequired.font = [UIFont TexasDrumsFontOfSize:14];
    self.peopleRequired.text = [NSString stringWithFormat:@"%@ snares, %@ tenors, %@ basses, %@ cymbals", [selection objectAtIndex:0], [selection objectAtIndex:1], [selection objectAtIndex:2], [selection objectAtIndex:3]];
}


@end
