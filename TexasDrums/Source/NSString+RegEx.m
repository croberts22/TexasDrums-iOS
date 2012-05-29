//
//  NSString+RegEx.m
//  TexasDrums
//
//  Created by Corey Roberts on 4/16/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "NSString+RegEx.h"

@implementation NSString (RegEx)

+ (NSString *)extractHTML:(NSString *)string {
    NSString *searchString = string;
    NSString *regexString = @"<.*?>";
    NSString *replaceWithString = @"";
    NSString *replacedString = NULL;
    
    replacedString = [searchString stringByReplacingOccurrencesOfRegex:regexString withString:replaceWithString];
    
    return replacedString;
}

+ (NSString *)stripExcessEscapes:(NSString *)string {
    
    NSString *searchString = string;
    NSString *regexString = @"(\r|\n)+";
    NSString *replaceWithString = @"\r\n";
    NSString *replacedString = NULL;
    
    replacedString = [searchString stringByReplacingOccurrencesOfRegex:regexString withString:replaceWithString];
    
    return replacedString;
}

@end
