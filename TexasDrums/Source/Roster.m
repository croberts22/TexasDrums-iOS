//
//  Roster.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/24/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "Roster.h"
#import "RosterMember.h"

@implementation Roster

@synthesize the_year, snares, tenors, basses, cymbals, instructor;

#pragma mark - Memory Management

- (id)initWithYear:(NSString *)year {
    if ((self = [super init])) {
        self.snares = [[NSMutableArray alloc] init];
        self.tenors = [[NSMutableArray alloc] init];
        self.basses = [[NSMutableArray alloc] init];
        self.cymbals = [[NSMutableArray alloc] init];
        self.instructor = [[NSMutableArray alloc] init];
        self.the_year = year;
    }
    
    return self;
}

- (void)dealloc {
    [the_year release], the_year = nil;
    [snares release], snares = nil;
    [tenors release], tenors = nil;
    [basses release], basses = nil;
    [cymbals release], cymbals = nil;
    [instructor release], instructor = nil;
    [super dealloc];
}

#pragma mark - Instance Methods

- (void)addMember:(RosterMember *)member {
    if([member.instrument isEqualToString:@"Snare"]){
        [self.snares addObject:member];
    }
    else if([member.instrument isEqualToString:@"Tenors"]){
        [self.tenors addObject:member];
    }
    else if([member.instrument isEqualToString:@"Bass"]){
        [self.basses addObject:member];
    }
    else if([member.instrument isEqualToString:@"Cymbals"]){
        [self.cymbals addObject:member];
    }
    else if([member.instrument isEqualToString:@"Instructor"]) {
        [self.instructor addObject:member];
    }
}

- (void)sortSections {
    // Snares are positioned opposite of everyone else because we're rebels.
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:NO];
    [self.snares sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [descriptor release];
    descriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
    [self.basses sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [self.tenors sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [self.cymbals sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [descriptor release];
}



@end
