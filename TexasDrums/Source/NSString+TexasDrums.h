//
//  NSString+TexasDrums.h
//  TexasDrums
//
//  Created by Corey Roberts on 7/28/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TexasDrums)

+ (NSString *)parsePhoneNumber:(NSString *)phone;
+ (NSString *)parseBirthday:(NSString *)birthday;

@end
