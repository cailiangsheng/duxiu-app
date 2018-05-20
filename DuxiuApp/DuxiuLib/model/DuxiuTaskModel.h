//
//  DXTaskModel.h
//  DuxiuDown
//
//  Created by 良胜 蔡 on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuDownloadModel.h"
#import "DuxiuCountModel.h"
#import "DuxiuExportModel.h"

#define EVENT_MODEL_BOOKTITLE_CHANGE @"eventModelBookTitleChange"
#define EVENT_MODEL_BOOKNAME_CHANGE @"eventModelBookNameChange"
#define EVENT_MODEL_BOOKHOME_CHANGE @"eventModelBookHomeChange"
#define EVENT_MODEL_BOOKSSNO_CHANGE @"eventModelBookSSNoChange"
#define EVENT_MODEL_BOOKSTR_CHANGE @"eventModelBookSTRChange"
#define EVENT_MODEL_BOOKSPAGE_CHANGE @"eventModelBookSPageChange"
#define EVENT_MODEL_BOOKEPAGE_CHANGE @"eventModelBookEPageChange"
#define EVENT_MODEL_PAGETYPE_CHANGE @"eventModelPageTypeChange"
#define EVENT_MODEL_PAGEZOOM_CHANGE @"eventModelPageZoomChange"
#define EVENT_MODEL_SAVEHOME_CHANGE @"eventModelSaveHomeChange"
#define EVENT_MODEL_FROMPAGE_CHANGE @"eventModelFromPageChange"
#define EVENT_MODEL_TOPAGE_CHANGE @"eventModelToPageChange"
#define EVENT_MODEL_LOG_CHANGE @"eventModelLogChange"

@interface DuxiuTaskModel : NSObject

@property (nonatomic, copy) NSString *bookSTR;
@property (nonatomic, copy) NSString *bookSSNo;
@property (nonatomic, copy) NSString *bookTitle;
@property (nonatomic, copy) NSString *startPage;
@property (nonatomic, copy) NSString *endPage;
@property (nonatomic, copy) NSString *pageType;
@property (nonatomic, copy) NSString *pageZoom;
@property (nonatomic, copy) NSString *saveHome;
@property (nonatomic, copy) NSString *log;

- (DuxiuDownloadModel *)downloadModel;
- (DuxiuCountModel *)countModel;
- (DuxiuExportModel *)exportModel;

- (NSString *)bookName;
- (NSString *)bookHome;

- (NSNumber *)fromPage;
- (NSNumber *)toPage;
- (NSNumber *)getFromPage:(NSString *)pageType;
- (NSNumber *)getToPage:(NSString *)pageType;
- (NSNumber *)getMinPageNo:(NSString *)pageType;
- (NSNumber *)getMaxPageNo:(NSString *)pageType;

- (BOOL)canFetchParams;
- (BOOL)canStartDownload;
- (BOOL)canStopDownload;
- (BOOL)canStartExport;
- (BOOL)canStopExport;
- (BOOL)canOpenPDF;
- (BOOL)canRename;
- (BOOL)canOriginRename;
- (BOOL)canOrderRename;

- (BOOL)startDownload;
- (BOOL)stopDownload;

- (BOOL)startExport;
- (BOOL)stopExport;

- (BOOL)fetchParams:(NSString *)url;

- (BOOL)isParamsValid;

- (void)save;

@end
