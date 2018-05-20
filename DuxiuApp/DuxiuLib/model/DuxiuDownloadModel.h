//
//  DuxiuDownloadModel.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

@class DuxiuTaskModel;

#define EVENT_MODEL_DOWNLOAD_BEGIN @"eventModelDownloadBegin"
#define EVENT_MODEL_DOWNLOAD_PAGE @"eventModelDownloadPage"
#define EVENT_MODEL_DOWNLOAD_COMPLETE @"eventModelDownloadComplete"
#define EVENT_MODEL_DOWNLOAD_STOP @"eventModelDownloadStop"

@interface DuxiuDownloadModel : NSObject

- (DuxiuDownloadModel *)initWithTaskModel:(DuxiuTaskModel *)taskModel;
- (BOOL)isDownloadable;
- (BOOL)isDownloading;
- (BOOL)execute;
- (BOOL)cancel;
- (BOOL)wakeUp;

@end
