//
//  PaymentViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 9/26/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface PaymentViewController : UIViewController {
    IBOutlet UITableView *paymentTable;
    IBOutlet UIActivityIndicatorView *indicator;
    NSMutableArray *memberList;
}

@property (nonatomic, retain) UITableView *paymentTable;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) NSMutableArray *memberList;


extern NSString *const TEXAS_DRUMS_API_ACCOUNTS;
extern NSString *const TEXAS_DRUMS_API_UPDATE_PAYMENT;

- (void)fetchMembers;
- (void)sortMembersByName;
- (void)updateUser:(NSString *)user withPayment:(int)paid;

@end
