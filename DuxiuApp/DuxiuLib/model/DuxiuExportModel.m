//
//  DuxiuExportModel.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-8.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuExportModel.h"

#import "DuxiuTaskModel.h"

#import "DuxiuBookPagesExporter.h"

@interface DuxiuExportModel ()

@property (weak) DuxiuTaskModel *taskModel;
@property (nonatomic) BOOL exporting;
@property (strong) DuxiuBookPagesExporter *exporter;

@end

@implementation DuxiuExportModel

@synthesize taskModel = _taskModel;
@synthesize exporting = _exporting;
@synthesize exporter = _exporter;

- (DuxiuExportModel *)initWithTaskModel:(DuxiuTaskModel *)taskModel
{
    if (self = [super init])
    {
        _taskModel = taskModel;
        _exporter = [[DuxiuBookPagesExporter alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onExportComplete:) name:EVENT_EXPORT_COMPLETE object:_exporter];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onExportError:) name:EVENT_EXPORT_ERROR object:_exporter];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onExportFailed:) name:EVENT_EXPORT_FAILED object:_exporter];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onExportStart:) name:EVENT_EXPORT_START object:_exporter];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onExportStep:) name:EVENT_EXPORT_STEP object:_exporter];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onExportStop:) name:EVENT_EXPORT_STOP object:_exporter];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_EXPORT_COMPLETE object:_exporter];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_EXPORT_ERROR object:_exporter];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_EXPORT_FAILED object:_exporter];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_EXPORT_START object:_exporter];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_EXPORT_STEP object:_exporter];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_EXPORT_STOP object:_exporter];
}

- (void)onExportComplete:(NSNotification *)notification
{
    _taskModel.log = [NSString stringWithFormat:@"%@\nEnd Exporting.", _taskModel.log];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_EXPORT_COMPLETE object:self userInfo:notification.userInfo];
}

- (void)onExportError:(NSNotification *)notification
{
    _taskModel.log = [NSString stringWithFormat:@"%@\nExport Error: %@  ×", _taskModel.log, [notification.userInfo valueForKey:@"data"]];
    
}

- (void)onExportFailed:(NSNotification *)notification
{
    _taskModel.log = [NSString stringWithFormat:@"%@\nExport Failed.", _taskModel.log];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_EXPORT_FAILED object:self userInfo:notification.userInfo];
}

- (void)onExportStart:(NSNotification *)notification
{
    _taskModel.log = @"Begin Exporting...";
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_EXPORT_BEGIN object:self userInfo:notification.userInfo];
}

- (void)onExportStep:(NSNotification *)notification
{
    _taskModel.log = [NSString stringWithFormat:@"%@\nExport Step: %@  √", _taskModel.log, [notification.userInfo valueForKey:@"data"]];
}

- (void)onExportStop:(NSNotification *)notification
{
    _taskModel.log = [NSString stringWithFormat:@"%@\nStop Exporting.", _taskModel.log];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_EXPORT_STOP object:self];
}

- (BOOL)isExportable
{
    return _taskModel.canRename;
}

- (BOOL)isExporting
{
    return _exporter.isExporting;
}

- (NSString *)defaultPdfPath
{
    return [DuxiuBookPagesExporter getPdfPath:_taskModel.bookHome];
}

- (BOOL)defaultPdfExist
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self defaultPdfPath]];
}

- (BOOL)export
{
    return [_exporter exportPdfFromPagesHome:_taskModel.bookHome];
}

- (BOOL)cancel
{
    return [_exporter cancel];
}

- (BOOL)wakeUp
{
    return [_exporter wakeUp];
}

@end
