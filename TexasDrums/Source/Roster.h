//
//  Roster.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/24/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Roster : NSObject {
    NSString *the_year;
    NSMutableArray *snares;
    NSMutableArray *tenors;
    NSMutableArray *basses;
    NSMutableArray *cymbals;
    NSMutableArray *instructor;
}

@property (nonatomic, retain) NSString *the_year;
@property (nonatomic, retain) NSMutableArray *snares;
@property (nonatomic, retain) NSMutableArray *tenors;
@property (nonatomic, retain) NSMutableArray *basses;
@property (nonatomic, retain) NSMutableArray *cymbals;
@property (nonatomic, retain) NSMutableArray *instructor;

- (id)initWithYear:(NSString *)year;

@end
