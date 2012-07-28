//
//  EditProfile.m
//  TexasDrums
//
//  Created by Corey Roberts on 7/27/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "EditProfile.h"

#import "GANTracker.h"
#import "SVProgressHUD.h"
#import "UIColor+TexasDrums.h"
#import "UIFont+TexasDrums.h"
#import "CJSONDeserializer.h"
#import "Common.h"

@implementation EditProfile

- (void)dismissWithSuccess {
    [SVProgressHUD dismiss];
}

- (void)dismissWithError {
    [SVProgressHUD showErrorWithStatus:@"Unable to save."];
}

@end
