//
//  DuxiuExportModel.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-8.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

@class DuxiuTaskModel;

#define EVENT_MODEL_EXPORT_BEGIN @"eventModelExportBegin"
#define EVENT_MODEL_EXPORT_COMPLETE @"eventModelExportComplete"
#define EVENT_MODEL_EXPORT_FAILED @"eventModelExportFailed"
#define EVENT_MODEL_EXPORT_STOP @"eventModelExportStop"

@interface DuxiuExportModel : NSObject

- (DuxiuExportModel *)initWithTaskModel:(DuxiuTaskModel *)taskModel;

- (BOOL)isExportable;
- (BOOL)isExporting;
- (NSString *)defaultPdfPath;
- (BOOL)defaultPdfExist;
- (BOOL)export;
- (BOOL)cancel;
- (BOOL)wakeUp;

@end
