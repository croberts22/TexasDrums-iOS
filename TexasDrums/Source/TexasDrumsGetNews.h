//
//  TexasDrumsGetNews.h
//  TexasDrums
//
//  Created by Corey Roberts on 6/3/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "TexasDrumsRequest.h"

@interface TexasDrumsGetNews : TexasDrumsRequest {
    NSInteger _timestamp;
}

- (id)initWithTimestamp:(NSInteger)timestamp;

@end
