//
//  AddressBookViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 8/14/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface AddressBookViewController : UIViewController<NSURLConnectionDelegate> {
    IBOutlet UITableView *addressBookTable;
    IBOutlet UISegmentedControl *sorter;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UILabel *status;
    NSMutableArray *addressBook;
    NSMutableDictionary *full_name;
    NSMutableDictionary *sections;
    NSMutableDictionary *membership;
    NSMutableData *received_data;
}

extern NSString *const TEXAS_DRUMS_API_ACCOUNTS;

@property (nonatomic, retain) UITableView *addressBookTable;
@property (nonatomic, retain) UISegmentedControl *sorter;
@property (nonatomic, retain) NSMutableArray *addressBook;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UILabel *status;
@property (nonatomic, retain) NSMutableDictionary *full_name;
@property (nonatomic, retain) NSMutableDictionary *sections;
@property (nonatomic, retain) NSMutableDictionary *membership;
@property (nonatomic, retain) NSMutableData *received_data;

- (void)sortMembersByName;
- (void)grabCharacters;
- (IBAction)sorterChanged:(id)sender;

@end
