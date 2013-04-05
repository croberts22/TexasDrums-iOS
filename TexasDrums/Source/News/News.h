//
//  News.h
//  TexasDrums
//
//  Created by Corey Roberts on 4/4/13.
//  Copyright (c) 2013 Corey Roberts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface News : NSManagedObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSDate *datePosted;
@property (nonatomic, retain) NSDate *dateEdited;
@property (nonatomic, retain) NSNumber *timestamp;
@property (nonatomic, retain) NSNumber *memberPost;
@property (nonatomic, retain) NSNumber *sticky;

@end
