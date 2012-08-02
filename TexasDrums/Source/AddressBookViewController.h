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
}

@property (nonatomic, retain) UITableView *addressBookTable;

- (void)sortMembersByName;
- (void)grabCharacters;
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;

@end
