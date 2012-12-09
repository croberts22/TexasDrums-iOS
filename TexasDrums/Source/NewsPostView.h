//
//  NewsPostView.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/27/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class News;

@interface NewsPostView : TexasDrumsViewController<UIWebViewDelegate> {
    News *post;
    IBOutlet UIWebView *webView;
    IBOutlet UILabel *titleOfPost;
    IBOutlet UILabel *dateAndAuthor;
    NSString *content;
    BOOL isMemberPost;
    BOOL loadPost;
}

@property (nonatomic, retain) News *post;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UILabel *titleOfPost;
@property (nonatomic, retain) UILabel *dateAndAuthor;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL isMemberPost;
@property (nonatomic, assign) BOOL loadPost;

@end
