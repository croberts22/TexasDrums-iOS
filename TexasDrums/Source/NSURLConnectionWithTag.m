//
//  NSURLConnectionWithTag.m
//  TexasDrums
//
//  Created by Corey Roberts on 5/15/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "NSURLConnectionWithTag.h"

@implementation NSURLConnectionWithTag
@synthesize tag;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately tag:(NSNumber *)_tag {
    self = [super initWithRequest:request delegate:delegate startImmediately:startImmediately];
    
    if(self) {
        self.tag = _tag;
    }
    
    return self;
}

@end
