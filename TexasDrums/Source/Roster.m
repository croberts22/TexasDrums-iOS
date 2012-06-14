//
//  Roster.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/24/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "Roster.h"


@implementation Roster

@synthesize the_year, snares, tenors, basses, cymbals, instructor;

- (id)initWithYear:(NSString *)year {
    if ((self = [super init])) {
        snares = [[NSMutableArray alloc] init];
        tenors = [[NSMutableArray alloc] init];
        basses = [[NSMutableArray alloc] init];
        cymbals = [[NSMutableArray alloc] init];
        instructor = [[NSMutableArray alloc] init];
        the_year = year;
    }
    
    return self;
}

@end
