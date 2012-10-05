//
//  Video.h
//  TexasDrums
//
//  Created by Corey Roberts on 4/13/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject {
    NSString *videoTitle;
    NSString *type;
    NSString *link;
    NSString *videoID;
    NSString *description;
    NSString *videoYear;
    NSString *videoDate;
    NSString *time;
    NSURL *thumbnail;
    int timestamp;
    BOOL valid;
}

@property (nonatomic, copy) NSString *videoTitle;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *videoID;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *videoYear;
@property (nonatomic, copy) NSString *videoDate;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, retain) NSURL *thumbnail;
@property (nonatomic, assign) int timestamp;
@property (nonatomic, assign) BOOL valid;

+ (Video *)createNewVideo:(NSDictionary *)item;

@end
