//
//  FAQViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 1/11/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "FAQViewController.h"
#import "TexasDrumsGetFAQ.h"
#import "FAQ.h"
#import "CJSONDeserializer.h"

@implementation FAQViewController

@synthesize FAQTable, faq, categories;

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Google Analytics
    [[GANTracker sharedTracker] trackPageview:@"FAQ (FAQView)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"FAQ"];
    
    // Allocate things as necessary.
    if(faq == nil){
        faq = [[NSMutableArray alloc] init];
        categories = [[NSMutableDictionary alloc] init];
    }
    
    // Set properties.
    self.FAQTable.backgroundColor = [UIColor clearColor];
    self.FAQTable.separatorColor = [UIColor clearColor];
    self.FAQTable.alpha = 0.0f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self connect];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI Methods

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont TexasDrumsBoldFontOfSize:20];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleView.textColor = [UIColor whiteColor]; 
        
        self.navigationItem.titleView = titleView;
        [titleView release];
    }
    titleView.text = title;
    [titleView sizeToFit];
}

- (void)refreshPressed {
    // Begin fetching FAQ from the server.
    [self connect];
}

- (void)hideRefreshButton {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
}

- (void)dismissWithSuccess {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [SVProgressHUD dismiss];
}

- (void)dismissWithError {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [SVProgressHUD showErrorWithStatus:@"Could not fetch data."];
}

- (void)displayTable {
    float duration = 0.5f;
    [self.FAQTable reloadData];
    [UIView beginAnimations:@"displayFAQTable" context:NULL];
    [UIView setAnimationDelay:duration];
    self.FAQTable.alpha = 1.0f;
    [UIView commitAnimations];
}

#pragma mark - Data Methods

- (void)connect {
    [self hideRefreshButton];
    TexasDrumsGetFAQ *get = [[TexasDrumsGetFAQ alloc] init];
    get.delegate = self;
    [get startRequest];    
}

- (void)parseFAQData:(NSDictionary *)results {
    
    // Iterate through the results and create FAQ objects.
    for(NSDictionary *item in results){        
        FAQ *question = [self createNewFAQ:item];
        [faq addObject:question];
    }
    
    [self countCategories];
    [self displayTable];
}

- (FAQ *)createNewFAQ:(NSDictionary *)item {
    FAQ *question = [[[FAQ alloc] init] autorelease];
    
    question.category = [item objectForKey:@"category"];
    question.question = [item objectForKey:@"question"];
    question.answer = [item objectForKey:@"answer"];
    question.valid = [[item objectForKey:@"valid"] boolValue];
    
    return question;
}

- (void)countCategories {
    for(FAQ *this_faq in faq){
        // Remove quotes.
        NSString *this_category = [[this_faq category] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        // If category doesn't exist in dictionary, add it.
        if([categories objectForKey:this_category] == nil){
            [categories setObject:@"1" forKey:this_category];
        }
        else{
            int incrementor = [[categories valueForKey:this_category] intValue] + 1;
            [categories setObject:[NSString stringWithFormat:@"%d", incrementor] forKey:this_category];
        }
    }
}


#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [categories count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //  Returns number of questions plus answers (questions * 2) per section.
    int counter = 0;
    for(id key in categories){
        if(counter == section){
            return [[categories objectForKey:key] intValue] * 2;
        }
        counter++;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    NSString *text;
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    int incrementor = 0;
    
    if(indexPath.section > 0){
        int counter = 1;
        for(id key in categories){
            incrementor += [[categories objectForKey:key] intValue];
            if(counter == indexPath.section){
                break;
            }
            counter++;
        }
    }
    
    //if cell is even, it is a question. else, it is an answer.
    //this sets the size of the frame based on the kind of font is used, as well as its sized.
    //this asserts that the cell will show all of the information.
    if(indexPath.row % 2 == 0){
        text = [[faq objectAtIndex:((indexPath.row / 2) + incrementor)] question];
        size = [text sizeWithFont:[UIFont fontWithName:@"Georgia-Bold" size:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    }
    else{
        text = [[faq objectAtIndex:((indexPath.row / 2) + incrementor)] answer];
        size = [text sizeWithFont:[UIFont fontWithName:@"Georgia" size:SMALL_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    }
    
    CGFloat height = size.height;
    return height + (CELL_CONTENT_MARGIN * 2);
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    // Create a custom header.
    int counter = 0;
    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, STANDARD_HEADER_HEIGHT)] autorelease];
    
    UILabel *headerTitle = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 25)] autorelease];
    
    // Determine the section header based on the section.
    for(id key in categories){
        headerTitle.text = key;
        if(counter == section){
            break;
        }
        counter++;
    }
    
    // Set header title properties.
    headerTitle.textAlignment = UITextAlignmentCenter;
    headerTitle.textColor = [UIColor TexasDrumsOrangeColor];
    headerTitle.font = [UIFont TexasDrumsBoldFontOfSize:18];
    headerTitle.backgroundColor = [UIColor clearColor];
    headerTitle.shadowOffset = CGSizeMake(0, 1);
    
    UIImage *headerImage = [UIImage imageNamed:@"header.png"];
    UIImageView *headerImageView = [[[UIImageView alloc] initWithImage:headerImage] autorelease];
    headerImageView.frame = CGRectMake(0, 0, 320, 30);

    [containerView addSubview:headerImageView];
    [containerView addSubview:headerTitle];
    
	return containerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *label = nil;
    
    if (cell == nil)
    {
        // Set cell properties.
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.numberOfLines = 0; // Infinite lines.
        label.backgroundColor = [UIColor clearColor];
        label.tag = 1;
        
        [[cell contentView] addSubview:label];
    }
    
    // Set properties.
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    NSString *text;
    CGSize size;
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    // For sections above the first one, increment through past questions from previous sections
    int incrementor = 0;
    if(indexPath.section > 0){
        int counter = 1;
        for(id key in categories){
            incrementor += [[categories objectForKey:key] intValue];
            if(counter == indexPath.section){
                break;
            }
            counter++;
        }
    }
    
    // If there's no label, use this to reload a label with a given tag.
    if (!label){
        label = (UILabel*)[cell viewWithTag:1];
    }
    
    // If a cell is even, then it is a question.
    // Otherwise, it is an answer.
    if(indexPath.row % 2 == 0){
        label.font = [UIFont TexasDrumsBoldFontOfSize:14];
        label.textColor = [UIColor TexasDrumsOrangeColor];
        text = [[faq objectAtIndex:((indexPath.row / 2) + incrementor)] question];
        size = [text sizeWithFont:[UIFont TexasDrumsBoldFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    }
    else{ 
        label.font = [UIFont TexasDrumsFontOfSize:12];
        label.textColor = [UIColor TexasDrumsGrayColor];
        text = [[faq objectAtIndex:((indexPath.row / 2) + incrementor)] answer];
        size = [text sizeWithFont:[UIFont TexasDrumsFontOfSize:12] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    }
    
    label.text = text;
    label.frame = CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), size.height);
    
    return cell;
}

#pragma mark TexasDrumsRequestDelegate Methods

- (void)request:(TexasDrumsRequest *)request receivedData:(id)data {
    TDLog(@"Obtained FAQ successfully.");
    
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:data error:&error];
    [self parseFAQData:results];
    
    [self dismissWithSuccess];
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    TDLog(@"request error: %@", error);
    
    // Show refresh button and error message.
    [self dismissWithError];
}

@end
