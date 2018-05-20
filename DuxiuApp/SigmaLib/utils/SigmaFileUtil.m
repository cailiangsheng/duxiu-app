//
//  SigmaFileUtil.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SigmaFileUtil.h"

#import "SigmaViewControllerUtil.h"

@interface DICUtil : NSObject <UIDocumentInteractionControllerDelegate>

@property (strong) UIViewController *viewController;
@property (strong) UIDocumentInteractionController *dic;

+ (BOOL)previewDocumentFile:(NSString *)filePath;
+ (BOOL)previewDocumentFile:(NSString *)filePath inViewController:(UIViewController *)viewController;

@end

static DICUtil *_dicUtil;

@implementation DICUtil

@synthesize viewController = _viewController;
@synthesize dic = _dic;

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return _viewController;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return _viewController.view.frame;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return _viewController.view;
}

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller
{
    [self reset];
}

- (void)reset
{
    if (self.dic)
    {
        [self.dic dismissPreviewAnimated:NO];
        self.dic.delegate = nil;
        self.dic = nil;
    }
    
    self.viewController = nil;
}

- (DICUtil *)initWithDIC:(UIDocumentInteractionController *)dic viewController:(UIViewController *)viewController
{
    if (self = [self init])
    {
        _dic = dic;
        _dic.delegate = self;
        _viewController = viewController;
    }
    return self;
}

+ (DICUtil *)instanceWithDIC:(UIDocumentInteractionController *)dic viewController:(UIViewController *)viewController
{
    if (_dicUtil == nil)
    {
        _dicUtil = [DICUtil alloc];
    }
    else
    {
        [_dicUtil reset];
    }
    
    _dicUtil = [_dicUtil initWithDIC:dic viewController:viewController];
    return _dicUtil;
}

+ (BOOL)previewDocumentFile:(NSString *)filePath inViewController:(UIViewController *)viewController
{
    BOOL result = false;
    
    if (viewController && [[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSURL *url = [NSURL fileURLWithPath:filePath];
        UIDocumentInteractionController *dic = [UIDocumentInteractionController interactionControllerWithURL:url];
        
        DICUtil *util = [DICUtil instanceWithDIC:dic viewController:viewController];
        result = [dic presentPreviewAnimated:YES];
        if (!result)
        {
            [util reset];
        }
    }
    return result;
}

+ (BOOL)previewDocumentFile:(NSString *)filePath
{
    UIViewController *viewController = [SigmaViewControllerUtil topModalViewControllerUntilClass:NSClassFromString(@"QLPreviewController")];
    
    [SigmaViewControllerUtil dismissAllPopoverAnimated:NO];
    
    return [DICUtil previewDocumentFile:filePath inViewController:viewController];
}

@end

//-------------------------------------------------------------
@implementation SigmaFileUtil

+ (BOOL)isOverwritable:(NSString *)filePath
{
    if ([[NSFileManager defaultManager] isWritableFileAtPath:filePath])
    {
        return true;
    }
    else
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath] && 
         [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil])
    {
        return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    return false;
}

+ (BOOL)createDirectory:(NSString *)dirPath
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath] && 
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil])
    {
//        NSLog(@"Create Directory: %@", dirPath);
        return YES;
    }
    return NO;
}

+ (BOOL)createFile:(NSString *)filePath
{
    // Check existence of parent directory
    NSString *parentDirectory = [filePath stringByDeletingLastPathComponent];
    [SigmaFileUtil createDirectory:parentDirectory];
    
    // try to create file
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath] && 
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil])
    {
//        NSLog(@"Create File: %@", filePath);
        return YES;
    }
    return NO;
}

+ (BOOL)writeBytes:(NSData *)bytes atFilePath:(NSString *)filePath
{
    if (bytes && filePath)
    {
        // check existence of file
        [SigmaFileUtil createFile:filePath];
        
        // write File
        return [bytes writeToFile:filePath atomically:YES];
    }
    return false;
}

+ (BOOL)exploreFile:(NSString *)filePath
{
    return [DICUtil previewDocumentFile:filePath];
}

static NSString *_homeDirectory = nil;
static NSString *_documentsDirectory = nil;
static NSString *_libraryDirectory = nil;
static NSString *_cachesDirectory = nil;

NSString *getDirectoryPath(NSSearchPathDirectory directory)
{
    NSArray *paths= NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)homeDirectory
{
    if (_homeDirectory == nil)
    {
        _homeDirectory = [[SigmaFileUtil documentsDirectory] stringByDeletingLastPathComponent];
    }
    return _homeDirectory;
}

+ (NSString *)documentsDirectory
{
    if (_documentsDirectory == nil)
    {
        _documentsDirectory = getDirectoryPath(NSDocumentDirectory);
    }
    return _documentsDirectory;
}

+ (NSString *)libraryDirectory
{
    if (_libraryDirectory == nil)
    {
        _libraryDirectory = getDirectoryPath(NSLibraryDirectory);
    }
    return _libraryDirectory;
}

+ (NSString *)cachesDirectory
{
    if (_cachesDirectory == nil)
    {
        _cachesDirectory = getDirectoryPath(NSCachesDirectory);
    }
    return _cachesDirectory;
}

@end
