//
//  MenuViewController.m
//  TexasDrums
//
//  Created by Corey Roberts on 4/4/13.
//  Copyright (c) 2013 Corey Roberts. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"

static const NSString *kCellNameKey = @"kCellNameKey";
static const NSString *kControllerKey = @"kControllerKey";

@interface MenuViewController ()

@property (nonatomic, copy) NSArray *viewControllers;

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        self.viewControllers = @[
                                 @{
                                     kCellNameKey : @"News",
                                     kControllerKey : @"NewsViewController"
                                     },
                                 @{
                                     kCellNameKey : @"Roster",
                                     kControllerKey : @"RosterViewController"
                                     }
                                 // more to be added.
                                 ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewControllers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.viewControllers[indexPath.row][kCellNameKey];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class class = NSClassFromString(self.viewControllers[indexPath.row][kControllerKey]);
    if(class) {
        UIViewController *viewController = [[class alloc] initWithNibName:NSStringFromClass([class class]) bundle:[NSBundle mainBundle]];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [self.revealViewController setFrontViewController:navigationController animated:YES];
    }
}

@end
