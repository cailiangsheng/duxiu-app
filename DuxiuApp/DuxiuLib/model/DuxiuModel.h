//
//  DuxiuModel.h
//  DuxiuDown
//
//  Created by 良胜 蔡 on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuBrowseModel.h"
#import "DuxiuTaskModel.h"

@interface DuxiuModel : NSObject

+ (DuxiuModel *)instance;

@property (nonatomic, strong) DuxiuBrowseModel *browseModel;
@property (nonatomic, strong) DuxiuTaskModel *taskModel;

- (void)activate;
- (void)deactivate;

- (BOOL)isBuzy;
- (BOOL)wakeUp;

@end
