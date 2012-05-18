//
//  Music.h
//  TexasDrums
//
//  Created by Corey Roberts on 3/30/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
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

@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *instrument;
@property (nonatomic) int year;
@property (nonatomic, retain) NSString *filetype;
@property (nonatomic, retain) NSString *status;
@property (nonatomic) BOOL valid;

@end
