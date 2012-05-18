//
//  Video.h
//  TexasDrums
//
//  Created by Corey Roberts on 4/13/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
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

@property (nonatomic, retain) NSString *videoTitle;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *videoID;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *videoYear;
@property (nonatomic, retain) NSString *videoDate;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSURL *thumbnail;
@property (nonatomic, assign) int timestamp;
@property (nonatomic, assign) BOOL valid;

@end
