//
//  Audio.h
//  TexasDrums
//
//  Created by Corey Roberts on 4/12/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Audio : NSObject {
    NSString *audioTitle;
    NSString *location;
    NSString *description;
    NSString *audioYear;
}

@property (nonatomic, retain) NSString *audioTitle;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *audioYear;

@end
