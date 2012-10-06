//
//  AboutUsViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 1/10/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TexasDrumsAPIConnection.h"

@interface AboutUsViewController : UIViewController<TexasDrumsAPIConnection> {
    IBOutlet UIImageView *image;
    IBOutlet UITextView *info;
}

@property (nonatomic, retain) UIImageView *image;
@property (nonatomic, retain) UITextView *info;

@end
