//
//  DuxiuBookPagesExporter.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-8.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EVENT_EXPORT_START @"eventExportStart"
#define EVENT_EXPORT_STEP @"eventExportStep"
#define EVENT_EXPORT_COMPLETE @"eventExportComplete"
#define EVENT_EXPORT_ERROR @"eventExportError"
#define EVENT_EXPORT_FAILED @"eventExportFailed"
#define EVENT_EXPORT_STOP @"eventExportStop"

@interface DuxiuBookPagesExporter : NSObject

- (BOOL)isExporting;
- (BOOL)cancel;
- (BOOL)wakeUp;

- (BOOL)exportPdfFromPagesHome:(NSString *)pagesHome toPdfPath:(NSString *)pdfPath;
- (BOOL)exportPdfFromPagesHome:(NSString *)pagesHome;

+ (NSString *)getPdfPath:(NSString *)pagesHome;

@end
