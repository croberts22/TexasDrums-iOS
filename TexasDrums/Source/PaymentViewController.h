//
//  PaymentViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 9/26/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TexasDrumsAPIConnection.h"

@interface PaymentViewController : TexasDrumsViewController<TexasDrumsAPIConnection, UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *paymentTable;
    NSMutableArray *memberList;
}

@property (nonatomic, retain) UITableView *paymentTable;
@property (nonatomic, retain) NSMutableArray *memberList;

@end
