//
//  FAQ.m
//  TexasDrums
//
//  Created by Corey Roberts on 1/11/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "FAQ.h"

@implementation FAQ 

@synthesize category, question, answer, valid;

#pragma mark - Memory Management

- (id)init {
    if((self = [super init])) {
        self.category = @"";
        self.question = @"";
        self.answer = @"";
        self.valid = NO;
    }
    
    return self;
}

- (void)dealloc {
    [category release], category = nil;
    [question release], question = nil;
    [answer release], answer = nil;
    [super dealloc];
}

#pragma mark - Class Methods

+ (FAQ *)createNewFAQ:(NSDictionary *)item {
    FAQ *question = [[[FAQ alloc] init] autorelease];
    
    question.category = [item objectForKey:@"category"];
    question.question = [item objectForKey:@"question"];
    question.answer = [item objectForKey:@"answer"];
    question.valid = [[item objectForKey:@"valid"] boolValue];
    
    return question;
}

@end
