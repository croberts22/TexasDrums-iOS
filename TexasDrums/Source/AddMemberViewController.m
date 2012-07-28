//
//  AddMemberViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 8/16/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "AddMemberViewController.h"

@implementation AddMemberViewController

@synthesize backgroundButton, addMemberTable;
@synthesize firstname_field, lastname_field, username_field, email_field, phone_field, birthday_field, classification_controller, instrument_controller, admin_controller;
@synthesize firstname, lastname, username, email, phone, birthday, classification, instrument, admin;


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

- (void)dealloc {
    [backgroundButton release];
    [super dealloc];
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
    [[GANTracker sharedTracker] trackPageview:@"Add Member (AddMemberView)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Add Member"];
    self.firstname = @"";
    self.lastname = @"";
    self.username = @"";
    self.email = @"";
    self.phone = @"";
    self.birthday = @"";
    self.classification = @"";
    self.instrument = @"";
    self.admin = @"";
    
    self.firstname_field = [[[UITextField alloc] init] autorelease];
    self.lastname_field = [[[UITextField alloc] init] autorelease];
    self.username_field = [[[UITextField alloc] init] autorelease];
    self.email_field = [[[UITextField alloc] init] autorelease];
    self.phone_field = [[[UITextField alloc] init] autorelease];
    self.birthday_field = [[[UITextField alloc] init] autorelease];
    self.classification_controller = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Current", @"Alumni", nil]] autorelease];
    self.instrument_controller = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Snare", @"Tenors", @"Bass", @"Cymbals", nil]] autorelease];
    self.admin_controller = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Yes", @"No", nil]] autorelease];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 6;
    }
    else if(section == 1){
        return 3;
    }
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    
    if (indexPath.section == 0) {
        switch (indexPath.row){
            case 0:
                cell.textLabel.text = @"First Name";
                self.firstname_field.frame = CGRectMake(120, 12, 170, 30);
                self.firstname_field.text = self.firstname;
                self.firstname_field.placeholder = @"";
                self.firstname_field.keyboardType = UIKeyboardTypeAlphabet;
                self.firstname_field.returnKeyType = UIReturnKeyNext;
                self.firstname_field.autocapitalizationType = UITextAutocapitalizationTypeWords;
                self.firstname_field.autocorrectionType = UITextAutocorrectionTypeNo;
                self.firstname_field.adjustsFontSizeToFitWidth = YES;
                self.firstname_field.delegate = self;
                [cell addSubview:firstname_field];
                break;
            case 1:
                cell.textLabel.text = @"Last Name";
                self.lastname_field.frame = CGRectMake(120, 12, 170, 30);
                self.lastname_field.text = self.lastname;
                self.lastname_field.placeholder = @"";
                self.lastname_field.keyboardType = UIKeyboardTypeAlphabet;
                self.lastname_field.returnKeyType = UIReturnKeyNext;
                self.lastname_field.autocapitalizationType = UITextAutocapitalizationTypeWords;
                self.lastname_field.autocorrectionType = UITextAutocorrectionTypeNo;
                self.lastname_field.adjustsFontSizeToFitWidth = YES;
                self.lastname_field.delegate = self;
                [cell addSubview:lastname_field];
                break;
            case 2:
                cell.textLabel.text = @"Username";
                self.username_field.frame = CGRectMake(120, 12, 170, 30);
                self.username_field.text = self.username;
                self.username_field.placeholder = @"";
                self.username_field.enabled = NO;
                self.username_field.keyboardType = UIKeyboardTypeAlphabet;
                self.username_field.returnKeyType = UIReturnKeyNext;
                self.username_field.autocapitalizationType = UITextAutocapitalizationTypeWords;
                self.username_field.autocorrectionType = UITextAutocorrectionTypeNo;
                self.username_field.adjustsFontSizeToFitWidth = YES;
                self.username_field.delegate = self;
                [cell addSubview:username_field];                
                break;
            case 3:
                cell.textLabel.text = @"Email";
                self.email_field.frame = CGRectMake(120, 12, 170, 30);
                self.email_field.text = self.email;
                self.email_field.placeholder = @"";
                self.email_field.keyboardType = UIKeyboardTypeEmailAddress;
                self.email_field.returnKeyType = UIReturnKeyNext;
                self.email_field.autocapitalizationType = UITextAutocapitalizationTypeNone;
                self.email_field.autocorrectionType = UITextAutocorrectionTypeNo;
                self.email_field.adjustsFontSizeToFitWidth = YES;
                self.email_field.delegate = self;
                [cell addSubview:email_field];   
                break;
            case 4:
                cell.textLabel.text = @"Phone #";
                self.phone_field.frame = CGRectMake(120, 12, 170, 30);
                self.phone_field.text = self.phone;
                self.phone_field.placeholder = @"";
                self.phone_field.keyboardType = UIKeyboardTypeNumberPad;
                self.phone_field.returnKeyType = UIReturnKeyNext;
                self.phone_field.adjustsFontSizeToFitWidth = YES;
                self.phone_field.delegate = self;
                [cell addSubview:phone_field];   
                break;
            case 5:
                cell.textLabel.text = @"Birthday";
                self.birthday_field.frame = CGRectMake(120, 12, 170, 30);
                self.birthday_field.text = self.birthday;
                self.birthday_field.placeholder = @"";
                self.birthday_field.keyboardType = UIKeyboardTypeNumberPad;
                self.birthday_field.returnKeyType = UIReturnKeyNext;
                self.birthday_field.adjustsFontSizeToFitWidth = YES;
                self.birthday_field.delegate = self;
                [cell addSubview:birthday_field];   
                break;
            default:
                break;
        }
    }
    else if(indexPath.section == 1){
        switch(indexPath.row) {
            case 0:
                cell.textLabel.text = @"Classification";
                self.classification_controller.frame = CGRectMake(130, 8, 170, 30);
                self.classification_controller.segmentedControlStyle = UISegmentedControlStyleBar;
                [cell addSubview:self.classification_controller];
                break;
            case 1:
                cell.textLabel.text = @"Instrument";
                self.instrument_controller.frame = CGRectMake(13, 8, 300, 30);
                self.instrument_controller.segmentedControlStyle = UISegmentedControlStyleBar;
                [cell addSubview:self.instrument_controller];
                break;
            case 2:
                cell.textLabel.text = @"Admin";
                self.admin_controller.frame = CGRectMake(130, 8, 170, 30);
                self.admin_controller.segmentedControlStyle = UISegmentedControlStyleBar;
                [cell addSubview:self.admin_controller];
                break;
            default:
                break;
        }
    }
    else{
        cell.textLabel.text = @"Add Member";
    }
    
    return cell;    
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField == firstname_field) {
        self.firstname = textField.text;
    }
    else if(textField == lastname_field) {
        self.lastname = textField.text;
    }
    else if(textField == email_field) {
        self.email = textField.text;
    }
    else if(textField == phone_field) { 
        self.phone = textField.text;
    }
    else if(textField == birthday_field) {
        self.birthday = textField.text;
    }
    if([firstname length] > 0 && [lastname length] > 0){
        NSString *generated_username = [self generateUsernameWithFirstName:firstname AndLastName:lastname];
        if(![self.username isEqualToString:generated_username]){
            self.username = generated_username;
            TDLog(@"Generating username = %@", self.username);
            [self.addMemberTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{	
	if(textField == self.firstname_field){
		[self.lastname_field becomeFirstResponder];
	}
	else if(textField == self.lastname_field){
        [self.email_field becomeFirstResponder];
    }
    else if(textField == self.email_field){
        [self.phone_field becomeFirstResponder];
    }
    
	return YES;
}

- (NSString *)generateUsernameWithFirstName:(NSString *)first AndLastName:(NSString *)last {

    return [[[NSString alloc] initWithFormat:@"%@%@", [[first lowercaseString] substringToIndex:1], [last lowercaseString]] autorelease];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}


@end
