//
//  DuxiuCountModel.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuBookPageCounter.h"

@class DuxiuTaskModel;

#define EVENT_MODEL_PAGECOUNT_CHAGNE @"eventModelPageCountChange"

@interface DuxiuCountModel : NSObject

- (DuxiuCountModel *)initWithTaskModel:(DuxiuTaskModel *)taskModel;
- (DuxiuBookPageCounter *)counter;
- (void)update;

@end
