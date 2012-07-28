//
//  Common.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/24/11.
//  Copyright 2011 SpacePyro Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"

// UITableView Header Heights
#define HEADER_HEIGHT               50
#define STANDARD_HEADER_HEIGHT      40

// UITableView Row Heights
#define DEFAULT_ROW_HEIGHT          44
#define STAFF_ROW_HEIGHT            90

#define SMALL_FONT_SIZE             12.0f
#define FONT_SIZE                   14.0f
#define SMALL_FONT_SIZE             12.0f
#define CELL_CONTENT_WIDTH          320.0f
#define CELL_CONTENT_MARGIN         10.0f

// Defined API Values
#define _200_OK                     @"200 OK"
#define _403_UNKNOWN_ERROR          @"403 UNKNOWN ERROR"
#define _404_UNAUTHORIZED           @"404 UNAUTHORIZED"
#define _405_INVALID_API_KEY        @"405 INVALID API KEY"
#define _NEWS_API_NO_NEW_ARTICLES   @"No new articles."
#define _GIGS_API_NO_GIGS_AVAILABLE @"No gigs available."

#define DOMAIN_PATH                 @"http://www.texasdrums.com/"

@interface Common : NSObject

extern NSString *const TEXAS_DRUMS_API_KEY;

extern NSString *const TEXAS_DRUMS_API_NEWS;
extern NSString *const TEXAS_DRUMS_API_ROSTER;

//not available
extern NSString *const TEXAS_DRUMS_API_MEDIA;

//Members-only API functions
extern NSString *const TEXAS_DRUMS_API_LOGIN;
extern NSString *const TEXAS_DRUMS_API_LOGOUT;
extern NSString *const TEXAS_DRUMS_API_PROFILE;
extern NSString *const TEXAS_DRUMS_API_ACCOUNTS;
extern NSString *const TEXAS_DRUMS_API_MUSIC;
extern NSString *const TEXAS_DRUMS_API_UPDATE_PAYMENT;
extern NSString *const TEXAS_DRUMS_API_EDIT_PROFILE;
extern NSString *const TEXAS_DRUMS_API_ABOUT;
extern NSString *const TEXAS_DRUMS_API_ABOUT;
extern NSString *const TEXAS_DRUMS_API_FAQ;
extern NSString *const TEXAS_DRUMS_API_STAFF;

extern Profile *_Profile;

extern BOOL const DEBUG_MODE;

@end
