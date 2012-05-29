//
//  Common.m
//  TexasDrums
//
//  Created by Corey Roberts on 6/24/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import "Common.h"


@implementation Common

NSString *const TEXAS_DRUMS_API_KEY = @"LwtP6NB2Y0hooXVZj29fwceVfp93D";

NSString *const TEXAS_DRUMS_API_NEWS = @"http://www.texasdrums.com/api/v1/news.php?";
NSString *const TEXAS_DRUMS_API_ROSTER = @"http://www.texasdrums.com/api/v1/roster.php?";

// not available
NSString *const TEXAS_DRUMS_API_MEDIA = @"http://www.texasdrums.com/api/v1/media.php?";

// Members-only API functions
NSString *const TEXAS_DRUMS_API_LOGIN = @"http://www.texasdrums.com/api/v1/login.php?";
NSString *const TEXAS_DRUMS_API_LOGOUT = @"http://www.texasdrums.com/api/v1/logout.php?";
NSString *const TEXAS_DRUMS_API_PROFILE = @"http://www.texasdrums.com/api/v1/profile.php?";
NSString *const TEXAS_DRUMS_API_ACCOUNTS = @"http://www.texasdrums.com/api/v1/accounts.php?";
NSString *const TEXAS_DRUMS_API_MUSIC = @"http://www.texasdrums.com/api/v1/music.php?";
NSString *const TEXAS_DRUMS_API_UPDATE_PAYMENT = @"http://www.texasdrums.com/api/v1/update_payment.php?";
NSString *const TEXAS_DRUMS_API_EDIT_PROFILE = @"http://www.texasdrums.com/api/v1/edit_profile.php?";
NSString *const TEXAS_DRUMS_API_ABOUT = @"http://www.texasdrums.com/api/v1/about.php?";
NSString *const TEXAS_DRUMS_API_FAQ = @"http://www.texasdrums.com/api/v1/faq.php?";
NSString *const TEXAS_DRUMS_API_STAFF = @"http://www.texasdrums.com/api/v1/staff.php?";


// User Profile
Profile *_Profile;

// Debug Mode; this will include NSLog statements in the console.
BOOL const DEBUG_MODE = NO;

@end
