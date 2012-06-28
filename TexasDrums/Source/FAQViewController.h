//
//  FAQViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 1/11/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAQ.h"
#import "Common.h"
#import "CJSONDeserializer.h"

@interface FAQViewController : UIViewController {
    IBOutlet UITableView *FAQTable;
    NSMutableArray *faq;
    NSMutableDictionary *categories;
}

@property (nonatomic, retain) UITableView *FAQTable;
@property (nonatomic, retain) NSMutableArray *faq;
@property (nonatomic, retain) NSMutableDictionary *categories;

- (void)fetchFAQ;
- (void)parseFAQData:(NSDictionary *)results;
- (void)countCategories;

@end
