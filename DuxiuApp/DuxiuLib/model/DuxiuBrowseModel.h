//
//  DuxiuBrowseModel.h
//  DuxiuDown
//
//  Created by 良胜 蔡 on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuBrowseItem.h"

#define EVENT_MODEL_BROWSE_LOCATION_CHANGE @"eventModelBrowseLocationChange"

@interface DuxiuBrowseModel : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *bookmarks;

@property (nonatomic, copy) NSString *location;

- (void)save;

@end
