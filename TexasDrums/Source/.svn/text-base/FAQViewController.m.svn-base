//
//  FAQViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 1/11/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import "FAQViewController.h"
#import "GANTracker.h"

@implementation FAQViewController

#define QUESTION_FONT_SIZE (14.0f)
#define ANSWER_FONT_SIZE (12.0f)
#define CELL_CONTENT_WIDTH (320.0f)
#define CELL_CONTENT_MARGIN (10.0f)
#define _HEADER_HEIGHT_ (40)

@synthesize FAQTable, faq, categories, indicator, status, received_data;

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
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont fontWithName:@"Georgia-Bold" size:20];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleView.textColor = [UIColor whiteColor]; 
        
        self.navigationItem.titleView = titleView;
        [titleView release];
    }
    titleView.text = title;
    [titleView sizeToFit];
}

- (void)displayTable {
    float delay = 1.0f;
    [self.FAQTable reloadData];
    [UIView beginAnimations:@"displayFAQTable" context:NULL];
    [UIView setAnimationDelay:delay];
    self.FAQTable.alpha = 1.0f;
    self.indicator.alpha = 0.0f;
    self.status.alpha = 0.0f;
    [UIView commitAnimations];
    [self.indicator performSelector:@selector(stopAnimating) withObject:nil afterDelay:delay+.25];
}

- (void)viewWillAppear:(BOOL)animated {
    [[GANTracker sharedTracker] trackPageview:@"FAQ (FAQView)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"FAQ"];
    
    if(faq == nil){
        faq = [[NSMutableArray alloc] init];
        categories = [[NSMutableDictionary alloc] init];
    }
    //set table properties
    self.FAQTable.backgroundColor = [UIColor clearColor];
    self.FAQTable.separatorColor = [UIColor clearColor];
    self.FAQTable.alpha = 0.0f;
    
    self.indicator.alpha = 1.0f;
    self.status.alpha = 1.0f;
    self.status.text = @"Loading...";
    
    [self fetchFAQ];
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

- (void)fetchFAQ {
    [self startConnection];
}

- (void)startConnection {
    NSString *API_Call = [NSString stringWithFormat:@"%@apikey=%@", TEXAS_DRUMS_API_FAQ, TEXAS_DRUMS_API_KEY];
    NSLog(@"%@", API_Call);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_Call] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLConnection *urlconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if(urlconnection) {
        received_data = [[NSMutableData data] retain];
    }
}

- (void)parseFAQData:(NSDictionary *)results {
    for(NSDictionary *item in results){
        FAQ *question = [[FAQ alloc] init];
        question.category = [item objectForKey:@"category"];
        question.question = [item objectForKey:@"question"];
        question.answer = [item objectForKey:@"answer"];
        question.valid = [[item objectForKey:@"valid"] boolValue];
        
        [faq addObject:question];
        
        [question release];
    }
    
    [self countCategories];
    [self displayTable];
}

- (void)countCategories {
    for(FAQ *this_faq in faq){
        NSString *this_category = [[this_faq category] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        //if category doesn't exist in dictionary, add it
        if([categories objectForKey:this_category] == nil){
            [categories setObject:@"1" forKey:this_category];
        }
        else{
            int incrementor = [[categories valueForKey:this_category] intValue] + 1;
            [categories setObject:[NSString stringWithFormat:@"%d", incrementor] forKey:this_category];
        }
    }
    //NSLog(@"%@", categories);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //sections divied up by categories 
    return [categories count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //returns number of questions plus answers (questions * 2) per section
    int counter = 0;
    for(id key in categories){
        if(counter == section){
            return [[categories objectForKey:key] intValue] * 2;
        }
        counter++;
    }
    
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    int counter = 0;
    //create a new view of size _HEADER_HEIGHT_, and place a label inside.
    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, _HEADER_HEIGHT_)] autorelease];
    
    //should be 0,0,300,30, but 10 looks nicer.
    UILabel *headerTitle = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 25)] autorelease];
    for(id key in categories){
        headerTitle.text = key;
        if(counter == section){
            break;
        }
        counter++;
    }
    headerTitle.textAlignment = UITextAlignmentCenter;
    headerTitle.textColor = [UIColor orangeColor];
    headerTitle.shadowOffset = CGSizeMake(0, 1);
    headerTitle.font = [UIFont fontWithName:@"Georgia-Bold" size:18];
    headerTitle.backgroundColor = [UIColor clearColor];
    
    UIImage *headerImage = [UIImage imageNamed:@"header.png"];
    UIImageView *headerImageView = [[[UIImageView alloc] initWithImage:headerImage] autorelease];
    headerImageView.frame = CGRectMake(0, 0, 320, 30);

    [containerView addSubview:headerImageView];
    [containerView addSubview:headerTitle];
    
	return containerView;
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
        size = [text sizeWithFont:[UIFont fontWithName:@"Georgia-Bold" size:QUESTION_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    }
    else{
        text = [[faq objectAtIndex:((indexPath.row / 2) + incrementor)] answer];
        size = [text sizeWithFont:[UIFont fontWithName:@"Georgia" size:ANSWER_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    }
    
    CGFloat height = size.height;
    return height + (CELL_CONTENT_MARGIN * 2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *label = nil;
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.numberOfLines = 0; //infinite lines
        label.backgroundColor = [UIColor clearColor];
        label.tag = 1;
        
        [[cell contentView] addSubview:label];
    }
    
    //UITableViewCell properties
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    NSString *text;
    CGSize size;
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    //for sections above the first one; increment through past questions from previous sections
    int incrementor = 0;
    if(indexPath.section > 0){
        int counter = 1;
        for(id key in categories){
            incrementor += [[categories objectForKey:key] intValue];
            if(counter == indexPath.section){
                //NSLog(@"incrementor: %d, indexPath.row: %d, cell: %d", incrementor, indexPath.row, (incrementor + indexPath.row));
                break;
            }
            counter++;
        }
    }
    
    //if we've no label, use this to reload the cell view. 
    //this prevents excessive and wasteful alloc'ing
    if (!label){
        label = (UILabel*)[cell viewWithTag:1];
    }
    
    //if cell is even, it is a question. otherwise, it is an answer.
    if(indexPath.row % 2 == 0){
        label.font = [UIFont fontWithName:@"Georgia-Bold" size:QUESTION_FONT_SIZE];
        label.textColor = [UIColor orangeColor];
        text = [[faq objectAtIndex:((indexPath.row / 2) + incrementor)] question];
        size = [text sizeWithFont:[UIFont fontWithName:@"Georgia-Bold" size:QUESTION_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        //NSLog(@"%@, %f", text, size.height);
    }
    else{ 
        label.font = [UIFont fontWithName:@"Georgia" size:ANSWER_FONT_SIZE];
        label.textColor = [UIColor lightGrayColor];
        text = [[faq objectAtIndex:((indexPath.row / 2) + incrementor)] answer];
        size = [text sizeWithFont:[UIFont fontWithName:@"Georgia" size:ANSWER_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    }
    
    label.text = text;
    label.frame = CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), size.height);
    
    return cell;
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
    NSLog(@"Connection failed! Error - %@ %@",
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
    [self.indicator stopAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:received_data error:&error];
    
    [self parseFAQData:results];
    NSLog(@"Succeeded! Received %d bytes of data", [received_data length]);
    
    // release the connection, and the data object
    [connection release];
    [received_data release];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
