//
//  AddressBookViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 8/14/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TexasDrumsAPIConnection.h"

@protocol TexasDrumsAPIConnection;

@interface AddressBookViewController : UIViewController<TexasDrumsAPIConnection, UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *addressBookTable;
    IBOutlet UISegmentedControl *sorter;
    NSMutableArray *addressBook;
    NSMutableDictionary *full_name;
    NSMutableDictionary *sections;
    NSMutableDictionary *membership;
}

@property (nonatomic, retain) UITableView *addressBookTable;
@property (nonatomic, retain) UISegmentedControl *sorter;
@property (nonatomic, retain) NSMutableArray *addressBook;
@property (nonatomic, retain) NSMutableDictionary *full_name;
@property (nonatomic, retain) NSMutableDictionary *sections;
@property (nonatomic, retain) NSMutableDictionary *membership;

- (IBAction)sorterChanged:(id)sender;
- (void)parseAddressBookData:(NSDictionary *)results;
- (Profile *)createNewProfile:(NSDictionary *)item;
- (void)sortMembersByName;
- (void)grabCharacters;
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;

@end
