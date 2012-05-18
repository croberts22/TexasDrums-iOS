//
//  NSString+RegEx.h
//  TexasDrums
//
//  Created by Corey Roberts on 4/16/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegexKitLite.h"

@interface NSString (RegEx)

+ (NSString *)stripExcessEscapes:(NSString *)string;
+ (NSString *)extractHTML:(NSString *)string;

@end
