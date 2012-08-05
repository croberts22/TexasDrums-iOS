//
//  GigRequirementsViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 8/4/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GigRequirementsViewControllerDelegate <NSObject>
- (void)gigRequirementsSelected:(NSArray *)selection;
@end

@interface GigRequirementsViewController : UIViewController {
    NSArray *peopleRequired;
    IBOutlet UITextField *snares;
    IBOutlet UITextField *tenors;
    IBOutlet UITextField *basses;
    IBOutlet UITextField *cymbals;
    id<GigRequirementsViewControllerDelegate> delegate;
}

@property (nonatomic, copy) NSArray *peopleRequired;
@property (nonatomic, retain) UITextField *snares;
@property (nonatomic, retain) UITextField *tenors;
@property (nonatomic, retain) UITextField *basses;
@property (nonatomic, retain) UITextField *cymbals;
@property (nonatomic, retain) id<GigRequirementsViewControllerDelegate> delegate;

@end
