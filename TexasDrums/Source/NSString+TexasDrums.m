//
//  NSString+TexasDrums.m
//  TexasDrums
//
//  Created by Corey Roberts on 7/28/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "NSString+TexasDrums.h"

@implementation NSString (TexasDrums)

+ (NSString *)parsePhoneNumber:(NSString *)phone {
    if([phone length] == 10) {
        return [NSString stringWithFormat:@"%@-%@-%@",  [phone substringWithRange:NSMakeRange(0, 3)],
                                                        [phone substringWithRange:NSMakeRange(3, 3)],
                                                        [phone substringWithRange:NSMakeRange(6, 4)]];
    }
    else if([phone length] == 7) {
        return [NSString stringWithFormat:@"%@-%@", [phone substringWithRange:NSMakeRange(0, 3)],
                                                    [phone substringWithRange:NSMakeRange(3, 4)]];
    }
    else return @"n/a";
}

+ (NSString *)parseBirthday:(NSString *)birthday {
    if([birthday length] == 8) {
    return [NSString stringWithFormat:@"%@-%@-%@",  [birthday substringWithRange:NSMakeRange(0, 2)],
                                                    [birthday substringWithRange:NSMakeRange(2, 2)],
                                                    [birthday substringWithRange:NSMakeRange(4, 4)]];
    }
    else return @"Not a valid birthday string. This string must be 8 characters long.";
}

@end
