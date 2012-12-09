//
//  MediaViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/19/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MediaViewController : TexasDrumsViewController {
    NSArray *mediaOptions;
}

@property (nonatomic, copy) NSArray *mediaOptions;

- (IBAction)audioButtonPressed:(id)sender;
- (IBAction)videoButtonPressed:(id)sender;

@end
