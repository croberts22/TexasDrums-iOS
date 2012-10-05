//
//  Music.h
//  TexasDrums
//
//  Created by Corey Roberts on 3/30/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Music : NSObject {
    NSString *filename;
    NSString *location;
    NSString *instrument;
    int year;
    NSString *filetype;
    NSString *status;
    BOOL valid;
}

@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *instrument;
@property (nonatomic, assign) int year;
@property (nonatomic, copy) NSString *filetype;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) BOOL valid;

+ (Music *)createNewMusic:(NSDictionary *)item;

@end
