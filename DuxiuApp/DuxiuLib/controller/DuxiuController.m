//
//  DuxiuController.m
//  DuxiuDown
//
//  Created by 良胜 蔡 on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuController.h"
#import "DuxiuModel.h"

#import "SigmaFileUtil.h"

static DuxiuController *_instance = nil;

@implementation DuxiuController

+ (DuxiuController *)instance
{
    if (_instance == nil)
    {
        _instance = [[DuxiuController alloc] init];
    }
    return _instance;
}

- (id)init
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDownloadComplete) name:EVENT_MODEL_DOWNLOAD_COMPLETE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDownloadStop) name:EVENT_MODEL_DOWNLOAD_STOP object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onExportComplete) name:EVENT_MODEL_EXPORT_COMPLETE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onExportFailed) name:EVENT_MODEL_EXPORT_FAILED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onExportStop) name:EVENT_MODEL_EXPORT_STOP object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_DOWNLOAD_COMPLETE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_DOWNLOAD_STOP object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_EXPORT_COMPLETE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_EXPORT_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_EXPORT_STOP object:nil];
}

- (void)onActivate
{
    [[DuxiuModel instance] activate];
}

- (void)onDeactivate
{
    [[DuxiuModel instance] deactivate];
}

- (void)onSleep
{
    [self onStopAll];
    
    [[DuxiuModel instance] deactivate];
}

- (void)onWakeUp
{
    [[DuxiuModel instance] wakeUp];
}

- (void)onBrowse:(NSString *)url
{
    [DuxiuModel instance].browseModel.location = url;
}

void alert(NSString *message)
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"读秀下载" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView performSelector:@selector(show) withObject:nil afterDelay:0];
}

- (void)onFetchParams
{
    if (![[DuxiuModel instance].taskModel fetchParams:[DuxiuModel instance].browseModel.location])
    {
        alert(@"无法获取参数!");
    }
}

- (void)onStartDownload
{
    if (![[DuxiuModel instance].taskModel startDownload])
    {
        alert(@"无法开始下载!");
    }
}

- (void)onStopDownload
{
    if (![[DuxiuModel instance].taskModel stopDownload])
    {
        alert(@"无法停止下载!");
    }
}

- (void)onStartExport
{
    if (![[DuxiuModel instance].taskModel startExport])
    {
        alert(@"无法开始导出PDF!");
    }
}

- (void)onStopExport
{
    if (![[DuxiuModel instance].taskModel stopExport])
    {
        alert(@"无法取消导出PDF!");
    }
}

- (void)onStopAll
{
    [[DuxiuModel instance].taskModel stopDownload];
    [[DuxiuModel instance].taskModel stopExport];
}

- (void)onSelectDirPath:(NSString *)dirPath
{
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir] && isDir)
    {
        [DuxiuModel instance].taskModel.saveHome = [dirPath stringByDeletingLastPathComponent];
        [DuxiuModel instance].taskModel.bookSTR = nil;
        [DuxiuModel instance].taskModel.startPage = nil;
        [DuxiuModel instance].taskModel.endPage = nil;
        [DuxiuModel instance].taskModel.bookTitle = [dirPath lastPathComponent];
        [DuxiuModel instance].taskModel.bookSSNo = nil;
    }
}

- (void)onOpenPDF
{
    if (![SigmaFileUtil exploreFile:[DuxiuModel instance].taskModel.exportModel.defaultPdfPath])
    {
        alert(@"无法打开PDF!");
    }
}

- (void)onOpenFile:(NSString *)filePath
{
    if (![SigmaFileUtil exploreFile:filePath])
    {
        alert(@"无法打开文件!");
    }
}

- (void)onBookTitleEdit:(NSString *)title
{
    [DuxiuModel instance].taskModel.bookTitle = title;
}

- (void)onPageTypeEidt:(NSString *)pageType
{
    [DuxiuModel instance].taskModel.pageType = pageType;
}

- (void)onBookSPageEdit:(NSString *)startPage
{
    [DuxiuModel instance].taskModel.startPage = startPage;
}

- (void)onBookEPageEdit:(NSString *)endPage
{
    [DuxiuModel instance].taskModel.endPage = endPage;
}

- (void)onPageZoomEdit:(NSString *)pageZoom
{
    [DuxiuModel instance].taskModel.pageZoom = pageZoom;
}

- (void)onSaveHomeEdit:(NSString *)saveHome
{
    [DuxiuModel instance].taskModel.saveHome = saveHome;
}

//..........................................
void notifyIdle()
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_CONTROLLER_IDLE object:_instance];
}

- (void)onDownloadComplete
{
    alert(@"下载完毕!");
    
    notifyIdle();
}

- (void)onDownloadStop
{
    alert(@"下载停止!");
    
    notifyIdle();
}

- (void)onExportComplete
{
    alert(@"导出完毕!");
    
    [self onOpenPDF];
    
    notifyIdle();
}

- (void)onExportFailed
{
    alert(@"导出失败!");
    
    notifyIdle();
}

- (void)onExportStop
{
    alert(@"导出停止!");
    
    notifyIdle();
}

@end
