//
//  MusicViewController.h
//  TexasDrums
//
//  Created by Corey Roberts on 4/6/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicViewController : UIViewController {
    IBOutlet UIWebView *webView;
    UIPrintInteractionController *printController;
    NSString *filename;
    NSString *url;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIPrintInteractionController *printController;
@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *url;

@end
