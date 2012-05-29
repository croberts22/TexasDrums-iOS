//
//  NewsPostView.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/27/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"


@interface NewsPostView : UIViewController<UIWebViewDelegate> {
    News *post;
    IBOutlet UIWebView <UIWebViewDelegate> *webView;
    IBOutlet UILabel *titleOfPost;
    IBOutlet UILabel *dateAndAuthor;
    IBOutlet UIActivityIndicatorView *indicator;
    NSString *content;
    BOOL isMemberPost;
    BOOL loadPost;
}


@property (nonatomic, retain) News *post;
@property (nonatomic, retain) UIWebView <UIWebViewDelegate> *webView;
@property (nonatomic, retain) UILabel *titleOfPost;
@property (nonatomic, retain) UILabel *dateAndAuthor;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, assign) BOOL isMemberPost;
@property (nonatomic, assign) BOOL loadPost;

@end
