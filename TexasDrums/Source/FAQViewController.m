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

@interface FAQViewController()

- (void)parseFAQData:(NSDictionary *)results;
- (void)countCategories;

@end

@implementation FAQViewController

@synthesize FAQTable, faq, categories;

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

- (void)dealloc {
    [FAQTable release], FAQTable = nil;
    [faq release], faq = nil;
    [categories release], categories = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
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
    
    [self connect];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI Methods

- (void)refreshPressed {
    // Begin fetching FAQ from the server.
    [self connect];
}

- (void)hideRefreshButton {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [SVProgressHUD showWithStatus:@"Loading..."];
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
    [self.FAQTable reloadData];
    [UIView animateWithDuration:0.5f animations:^{
        self.FAQTable.alpha = 1.0f;
    }];
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
        FAQ *question = [FAQ createNewFAQ:item];
        [faq addObject:question];
    }
    
    [self countCategories];
    [self displayTable];
}

- (void)countCategories {
    for(FAQ *this_faq in faq){
        // Remove quotes.
        NSString *this_category = [this_faq.category stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
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

#pragma mark - UITableView Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [categories count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle;
    int counter = 0;
    
    // Determine the section header based on the section.
    for(id key in categories){
        sectionTitle = key;
        if(counter == section){
            break;
        }
        counter++;
    }
    
    UIView *header = [UIView TexasDrumsFAQTableHeaderViewWithTitle:sectionTitle];
    
	return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *label = nil;
    
    if (cell == nil)
    {
        // Set cell properties.
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.numberOfLines = 0; 
        label.backgroundColor = [UIColor clearColor];
        label.tag = 1;
        
        [[cell contentView] addSubview:label];
    }
    
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
                TDLog(@"No FAQ data found. Request returned: %@", [results objectForKey:@"status"]);
                [self dismissWithSuccess];
                return;
            }
        }
        
        TDLog(@"New FAQ data found. Parsing..");
        // Deserialize JSON results and parse them into FAQ objects.
        
        [self parseFAQData:results];
    }

    [self dismissWithSuccess];
}

- (void)request:(TexasDrumsRequest *)request failedWithError:(NSError *)error {
    TDLog(@"Request error: %@", error);
    
    // Show refresh button and error message.
    [self dismissWithError];
}

@end
