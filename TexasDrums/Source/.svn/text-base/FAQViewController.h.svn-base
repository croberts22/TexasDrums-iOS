//
//  FAQViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 1/11/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAQ.h"
#import "Common.h"
#import "CJSONDeserializer.h"

@interface FAQViewController : UIViewController {
    IBOutlet UITableView *FAQTable;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UILabel *status;
    NSMutableArray *faq;
    NSMutableDictionary *categories;
    NSMutableData *received_data;
}

@property (nonatomic, retain) UITableView *FAQTable;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UILabel *status;
@property (nonatomic, retain) NSMutableArray *faq;
@property (nonatomic, retain) NSMutableDictionary *categories;
@property (nonatomic, retain) NSMutableData *received_data;

- (void)fetchFAQ;
- (void)parseFAQData:(NSDictionary *)results;
- (void)countCategories;

@end
