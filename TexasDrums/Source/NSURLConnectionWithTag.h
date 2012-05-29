//
//  NSURLConnectionWithTag.h
//  TexasDrums
//
//  Created by Corey Roberts on 5/15/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLConnectionWithTag : NSURLConnection {
    NSNumber *tag;
}

@property (nonatomic, retain) NSNumber *tag;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately tag:(NSNumber *)_tag;

@end
