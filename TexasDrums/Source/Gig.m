//
//  Gig.m
//  TexasDrums
//
//  Created by Corey Roberts on 7/14/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "Gig.h"

@implementation Gig

@synthesize gig_name, gig_id, location, description, timestamp_string;
@synthesize timestamp, snares_required, snares_current, tenors_required, tenors_current, basses_required, basses_current, cymbals_required, cymbals_current;
@synthesize users;

- (id)init {
    if (self = [super init]) {
        gig_name = @"";
        gig_id = -1;
        location = @"";
        description = @"";
        users = [[NSMutableArray alloc] init];
        timestamp = 0;
        timestamp_string = @"";
        snares_required = 0;
        snares_current = 0;
        tenors_required = 0;
        tenors_current = 0;
        basses_required = 0;
        basses_current = 0;
        cymbals_required = 0;
        cymbals_current = 0;
    }
    return self;
}

- (void)dealloc {
    [users release];
    [super dealloc];
}

- (void)convertTimestampToString {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.timestamp];
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setTimeStyle:NSDateFormatterShortStyle];
    self.timestamp_string = [format stringFromDate:date];
}

- (NSString *)createRequiredText {
    return [NSString stringWithFormat:@"%d Snares\n%d Tenors\n%d Basses\n%d Cymbals", snares_required, tenors_required, basses_required, cymbals_required];
}

- (NSString *)createCurrentText {
    return [NSString stringWithFormat:@"%d Snares\n%d Tenors\n%d Basses\n%d Cymbals", snares_required-snares_current, tenors_required-tenors_current, basses_required-basses_current, cymbals_required-cymbals_current];
}

@end
