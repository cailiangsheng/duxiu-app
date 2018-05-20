//
//  DuxiuDownloadModel.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuDownloadModel.h"

#import "DuxiuBookPageIterator.h"
#import "DuxiuBookPageDownloader.h"

#import "DuxiuBookPageDefine.h"
#import "DuxiuBookPageData.h"

#import "SigmaFileUtil.h"

@interface DuxiuDownloadModel ()

@property (weak) DuxiuTaskModel *taskModel;
@property (nonatomic) BOOL downloading;

@property (strong) DuxiuBookPageIterator *iterator;
@property (strong) DuxiuBookPageDownloader *downloader;

@end

@implementation DuxiuDownloadModel

@synthesize taskModel = _taskModel;
@synthesize downloading = _downloading;

@synthesize iterator = _iterator;
@synthesize downloader = _downloader;

- (DuxiuDownloadModel *)initWithTaskModel:(DuxiuTaskModel *)taskModel
{
    if (self = [super init])
    {
        _taskModel = taskModel;
        _iterator = [[DuxiuBookPageIterator alloc] initWithTaskModel:taskModel];
        _downloader = [[DuxiuBookPageDownloader alloc] init];
    }
    return self;
}

- (DuxiuBookPageZoom *)targetPageZoom
{
    return [DuxiuBookPageDefine getPageZoom:_taskModel.pageZoom];
}

- (BOOL)isDownloadable
{
    return _taskModel.isParamsValid && 
            [self targetPageZoom] && 
            ([DuxiuBookPageDefine isFuzzyPageType:_taskModel.pageType] || 
             (_taskModel.fromPage && _taskModel.toPage && _taskModel.fromPage.intValue <= _taskModel.toPage.intValue) || 
             (_taskModel.fromPage && _taskModel.toPage == nil));
}

- (BOOL)isDownloading
{
    return _downloading;
}

- (BOOL)wakeUp
{
    return [_downloader wakeUp];
}

- (BOOL)execute
{
    if (!_downloading && 
        _downloader && 
        [_downloader setSTR:_taskModel.bookSTR])
    {
        _downloading = true;
        
        _taskModel.log = @"Begin Downloading...";
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_DOWNLOAD_BEGIN object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDownloadStart:) name:EVENT_DOWNLOADER_START object:_downloader];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDownloadComplete:) name:EVENT_DOWNLOADER_COMPLETE object:_downloader];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDownloadError:) name:EVENT_DOWNLOADER_ERROR object:_downloader];
        
        [_iterator setPageType:_taskModel.pageType];
        [self doExecute];
        return true;
    }
    return false;
}

- (BOOL)cancel
{
    if (_downloading)
    {
        _downloading = false;
        
        _taskModel.log = [NSString stringWithFormat:@"%@\nStop Downloading.", _taskModel.log];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_DOWNLOAD_STOP object:self];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_DOWNLOADER_START object:_downloader];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_DOWNLOADER_COMPLETE object:_downloader];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_DOWNLOADER_ERROR object:_downloader];
        [_downloader cancel];
        
        return true;
    }
    return false;
}

- (BOOL)stop
{
    if (_downloading)
    {
        _downloading = false;
        
        _taskModel.log = [NSString stringWithFormat:@"%@\nEnd Downloading.", _taskModel.log];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_DOWNLOAD_COMPLETE object:self];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_DOWNLOADER_START object:_downloader];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_DOWNLOADER_COMPLETE object:_downloader];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_DOWNLOADER_ERROR object:_downloader];
        return true;
    }
    return false;
}

- (void)doExecute
{
    if (_iterator.isValid)
    {
        DuxiuBookPageType *pageType = _iterator.curPageType;
        NSString *pageOriginName = [DuxiuBookPageDefine getPageOriginNameByType:pageType.typeName pageNo:[NSNumber numberWithInt:_iterator.curPageNumber]];
        NSString *pageOrderName = [DuxiuBookPageDefine getPageOrderNameByType:pageType.typeName pageNo:[NSNumber numberWithInt:_iterator.curPageNumber]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self getPageFilePath:pageOriginName]])
        {
            //[self onPageFileExist:pageOriginName];
            
            // not too frequent to carry on page iteration
            [self performSelector:@selector(onPageFileExist:) withObject:pageOriginName afterDelay:0];
        }
        else if ([[NSFileManager defaultManager] fileExistsAtPath:[self getPageFilePath:pageOrderName]])
        {
            NSString *pageFileName = [NSString stringWithFormat:@"%@(%@)", pageOriginName, pageOrderName];
            //[self onPageFileExist:pageFileName];
            
            // not too frequent to carry on page iteration
            [self performSelector:@selector(onPageFileExist:) withObject:pageFileName afterDelay:0];
        }
        else
        {
            [_downloader downloadWithPageName:pageOriginName zoomEnum:[self targetPageZoom].zoomEnum];
        }
    }
    else
    {
        [self stop];
    }
}

- (NSString *)getPageFilePath:(NSString *)pageName
{
    return [NSString stringWithFormat:@"%@/%@.png", _taskModel.bookHome, pageName];
}

- (void)onDownloadStart:(NSNotification *)notification
{
    NSString *data = [notification.userInfo valueForKey:@"data"];
    _taskModel.log = [NSString stringWithFormat:@"%@\nDownloading:  %@", _taskModel.log, data];
}

- (void)onDownloadComplete:(NSNotification *)notification
{
    DuxiuBookPageData *data = [notification.userInfo valueForKey:@"data"];
    NSString *filePath = [self getPageFilePath:data.pageName];
    if ([SigmaFileUtil writeBytes:data.pageBytes atFilePath:filePath])
    {
        _taskModel.log = [NSString stringWithFormat:@"%@\nDownloaded:  %@  √", _taskModel.log, data.pageName];
    
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_DOWNLOAD_PAGE object:self];
        
        [_iterator nextPageNumber];
        [self doExecute];
    }
    else
    {
        _taskModel.log = [NSString stringWithFormat:@"%@\nFailed to save:  %@  ×", _taskModel.log, filePath];
        [self cancel];
    }
}

- (void)onPageFileExist:(NSString *)pageName
{
    if (!_downloading)
        return;
    
    NSLog(@"Already Exist: %@", pageName);
    
    _taskModel.log = [NSString stringWithFormat:@"%@\nAlready Exist:  %@  √", _taskModel.log, pageName];
    
    [_iterator nextPageNumber];
    [self doExecute];
}

- (void)onDownloadError:(NSNotification *)notification
{
    NSString *data = [notification.userInfo valueForKey:@"data"];
    _taskModel.log = [NSString stringWithFormat:@"%@\nFailed to load:  %@  ×", _taskModel.log, data];
    
    if ([DuxiuBookPageDefine isContentPageType:_iterator.curPageType.typeName])
    {
        [_iterator nextPageNumber];
    }
    else
    {
        [_iterator nextPageType];
    }
    [self doExecute];
}

@end
