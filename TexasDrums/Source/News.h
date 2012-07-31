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

@property (nonatomic, copy) NSString *titleOfPost;
@property (nonatomic, copy) NSString *post;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *postDate;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) BOOL memberPost;
@property (nonatomic, assign) BOOL sticky;
@property (nonatomic, assign) int timestamp;

- (id)init;
+ (News *)createNewPost:(NSDictionary *)item;

@end
