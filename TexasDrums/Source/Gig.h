//
//  Gig.h
//  TexasDrums
//
//  Created by Corey Roberts on 7/14/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gig : NSObject {
    NSString *gig_name;
    NSString *gig_id;
    NSMutableArray *users;
}

@property (nonatomic, retain) NSString *gig_name;
@property (nonatomic, retain) NSString *gig_id;
@property (nonatomic, retain) NSMutableArray *users;

@end
