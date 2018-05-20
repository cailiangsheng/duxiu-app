//
//  DuxiuController.h
//  DuxiuDown
//
//  Created by 良胜 蔡 on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define EVENT_CONTROLLER_IDLE @"eventControllerIdle"

@interface DuxiuController : NSObject

+ (DuxiuController *)instance;

- (void)onActivate;
- (void)onDeactivate;
- (void)onSleep;
- (void)onWakeUp;

- (void)onBrowse:(NSString *)url;
- (void)onFetchParams;

- (void)onStartDownload;
- (void)onStopDownload;

- (void)onStartExport;
- (void)onStopExport;

- (void)onStopAll;

- (void)onSelectDirPath:(NSString *)dirPath;
- (void)onOpenPDF;
- (void)onOpenFile:(NSString *)filePath;

- (void)onBookTitleEdit:(NSString *)title;
- (void)onPageTypeEidt:(NSString *)pageType;
- (void)onBookSPageEdit:(NSString *)startPage;
- (void)onBookEPageEdit:(NSString *)endPage;
- (void)onPageZoomEdit:(NSString *)pageZoom;
- (void)onSaveHomeEdit:(NSString *)saveHome;


@end
