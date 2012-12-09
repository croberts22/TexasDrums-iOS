//
//  AboutThisAppViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 1/13/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutThisAppViewController : TexasDrumsViewController {
    IBOutlet UITextView *aboutInfo;
}

@property (nonatomic, retain) UITextView *aboutInfo;

@end
