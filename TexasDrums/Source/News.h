//
//  News.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/24/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface News : NSObject {
    NSString *titleOfPost;
    NSString *post;
    NSString *subtitle;
    NSString *author;
    NSString *postDate;
    NSString *time;
    BOOL memberPost;
    BOOL sticky;
    int timestamp;
}

@property (nonatomic, retain) NSString *titleOfPost;
@property (nonatomic, retain) NSString *post;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *postDate;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, assign) BOOL memberPost;
@property (nonatomic, assign) BOOL sticky;
@property (nonatomic, assign) int timestamp;

@end
