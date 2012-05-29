//
//  TexasDrumsTable.h
//  TexasDrums
//
//  Created by Corey Roberts on 5/21/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TexasDrumsTable <NSObject>

- (void)displayTable;

// UITableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


// UITableView Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
