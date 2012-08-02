//
//  FAQ.h
//  TexasDrums
//
//  Created by Corey Roberts on 1/11/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FAQ : NSObject {
    NSString *category;
    NSString *question;
    NSString *answer;
    BOOL valid;
}


@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *question;
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, assign) BOOL valid;

- (id)init;
+ (FAQ *)createNewFAQ:(NSDictionary *)item;

@end
