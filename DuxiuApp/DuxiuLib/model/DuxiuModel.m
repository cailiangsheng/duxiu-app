//
//  DuxiuModel.m
//  DuxiuDown
//
//  Created by 良胜 蔡 on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuModel.h"

static DuxiuModel *_instance = nil;

@implementation DuxiuModel

@synthesize browseModel = _browseModel;
@synthesize taskModel = _taskModel;

+ (DuxiuModel *)instance
{
    if (_instance == nil)
    {
        _instance = [[DuxiuModel alloc] init];
    }
    return _instance;
}

- (DuxiuBrowseModel *)browseModel
{
    if (_browseModel == nil)
    {
        _browseModel = [[DuxiuBrowseModel alloc] init];
    }
    return _browseModel;
}

- (DuxiuTaskModel *)taskModel
{
    if (_taskModel == nil)
    {
        _taskModel = [[DuxiuTaskModel alloc] init];
    }
    return _taskModel;
}

- (void)activate
{
    [self.taskModel.countModel update];
}

- (void)deactivate
{
    [self.browseModel save];
    [self.taskModel save];
}

- (BOOL)isBuzy
{
    return self.taskModel.downloadModel.isDownloading || self.taskModel.exportModel.isExporting;
}

- (BOOL)wakeUp
{
    return [self.taskModel.downloadModel wakeUp] || [self.taskModel.exportModel wakeUp];
}

@end
