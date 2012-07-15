//
//  Gig.m
//  TexasDrums
//
//  Created by Corey Roberts on 7/14/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "Gig.h"

@implementation Gig

@synthesize gig_id, gig_name, users;

- (id)init {
    if (self = [super init]) {
        users = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [users release];
    [super dealloc];
}

@end
