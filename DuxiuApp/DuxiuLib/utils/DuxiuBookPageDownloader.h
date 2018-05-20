//
//  DuxiuBookPageDownloader.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#define EVENT_DOWNLOADER_START @"eventDownloadStart"
#define EVENT_DOWNLOADER_ERROR @"eventDownloadError"
#define EVENT_DOWNLOADER_COMPLETE @"eventDownloadComplete"

@interface DuxiuBookPageDownloader : NSObject

- (DuxiuBookPageDownloader *)init;
- (BOOL)setSTR:(NSString *)str;
- (BOOL)downloadWithPageName:(NSString *)pageName zoomEnum:(int)zoomEnum;
- (BOOL)downloadWithPageName:(NSString *)pageName zoomEnum:(int)zoomEnum retryCount:(int)retryCount;
- (void)cancel;
- (BOOL)wakeUp;

@end
