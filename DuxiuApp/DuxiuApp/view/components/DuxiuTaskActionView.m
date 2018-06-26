//
//  DuxiuTaskActionView.m
//  DuxiuDown
//
//  Created by 良胜 蔡 on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuTaskActionView.h"

#import "DuxiuModel.h"
#import "DuxiuController.h"

#import "SigmaViewControllerUtil.h"

@interface DuxiuTaskActionView () <UIActionSheetDelegate>

@property (nonatomic, strong) UIActionSheet *actionSheet;

@property (nonatomic) SEL showHandler;
@property (strong) id showParam;

@end

static DuxiuTaskActionView *_instance = nil;

@implementation DuxiuTaskActionView

@synthesize actionSheet = _actionSheet;

@synthesize showHandler = _showHandler;
@synthesize showParam = _showParam;

+ (DuxiuTaskActionView *)instance
{
    if (_instance == nil)
    {
        _instance = [[DuxiuTaskActionView alloc] init];
    }
    return _instance;
}

- (id)init
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTaskStop) name:EVENT_MODEL_DOWNLOAD_COMPLETE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTaskStop) name:EVENT_MODEL_DOWNLOAD_STOP object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTaskStop) name:EVENT_MODEL_EXPORT_COMPLETE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTaskStop) name:EVENT_MODEL_EXPORT_FAILED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTaskStop) name:EVENT_MODEL_EXPORT_STOP object:nil];
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

- (void)onTaskStop
{
    [self refresh];
}

- (UIActionSheet *)createActionSheet
{
    [self dismiss];
    
    _actionSheet = [[UIActionSheet alloc] init];
    _actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    _actionSheet.delegate = self;
    _actionSheet.title = @"";
    
    if ([DuxiuModel instance].taskModel.canFetchParams)
        [_actionSheet addButtonWithTitle:@"获取参数"];
    
    if ([DuxiuModel instance].taskModel.canStartDownload)
        [_actionSheet addButtonWithTitle:@"开始下载"];
    
    if ([DuxiuModel instance].taskModel.canStopDownload)
        [_actionSheet addButtonWithTitle:@"停止下载"];
    
    if ([DuxiuModel instance].taskModel.canStartExport)
        [_actionSheet addButtonWithTitle:@"导出PDF"];
    
    if ([DuxiuModel instance].taskModel.canStopExport)
        [_actionSheet addButtonWithTitle:@"取消导出"];
    
    if ([DuxiuModel instance].taskModel.canOpenPDF)
        [_actionSheet addButtonWithTitle:@"打开PDF"];
    
    [_actionSheet addButtonWithTitle:@"取消"];
    _actionSheet.destructiveButtonIndex = 0;
    _actionSheet.cancelButtonIndex = _actionSheet.numberOfButtons - 1;
    return _actionSheet;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismiss];
    
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    SEL handler = nil;
    
    if ([title isEqualToString:@"获取参数"])
        handler = @selector(onFetchParams);
    else if ([title isEqualToString:@"开始下载"])
        handler = @selector(onStartDownload);
    else if ([title isEqualToString:@"停止下载"])
        handler = @selector(onStopDownload);
    else if ([title isEqualToString:@"导出PDF"])
        handler = @selector(onStartExport);
    else if ([title isEqualToString:@"取消导出"])
        handler = @selector(onStopExport);
    else if ([title isEqualToString:@"打开PDF"])
        handler = @selector(onOpenPDF);
    
    if (handler)
        [[DuxiuController instance] performSelector:handler withObject:nil afterDelay:0];
}

//-------------------------------------------------------------------------
static int ARROW_HEIGHT = 10;

- (void)showInRootViewFrom:(UIView *)view arrowDirection:(UIPopoverArrowDirection)direction
{
    CGRect sheetRect = _actionSheet.frame;
    sheetRect.origin.x = (view.frame.size.width - sheetRect.size.width) / 2;
    sheetRect.origin.y = (view.frame.size.height - sheetRect.size.height) / 2;
    
    if (direction == UIPopoverArrowDirectionUp)
        sheetRect.origin.y = view.frame.size.height - ARROW_HEIGHT;
    else if (direction == UIPopoverArrowDirectionDown)
        sheetRect.origin.y = - sheetRect.size.height + ARROW_HEIGHT;
    else if (direction == UIPopoverArrowDirectionLeft)
        sheetRect.origin.x = view.frame.size.width - ARROW_HEIGHT;
    else if (direction == UIPopoverArrowDirectionRight)
        sheetRect.origin.x = sheetRect.size.width + ARROW_HEIGHT;
    
    UIView *rootView = [[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController] view];
    CGRect rect = [view convertRect:sheetRect toView:rootView];
    [_actionSheet showFromRect:rect inView:rootView animated:YES];
}

//-------------------------------------------------------------------------
- (void)refresh
{
    if ([SigmaViewControllerUtil getPopoverControllerWithView:_actionSheet])
    {
        if (_showHandler)
        {
            [self performSelector:_showHandler withObject:_showParam];
        }
    }
    else
    {
        [self dismissAnimated:YES];
    }
}

- (BOOL)dismiss
{
    [self dismissAnimated:NO];
}

- (BOOL)dismissAnimated:(BOOL)animated
{
    if (_actionSheet)
    {
        [_actionSheet dismissWithClickedButtonIndex:_actionSheet.cancelButtonIndex animated:animated];
        _actionSheet = nil;
        _showHandler = nil;
        _showParam = nil;
        return YES;
    }
    return NO;
}

- (void)showFromTabBar:(UITabBar *)tabBar
{
    @try
    {
        [[self createActionSheet] showFromTabBar:tabBar];
        NSLog(@"showFromTabBar done!");
    }
    @catch (NSException *exception)
    {
        [self showInRootViewFrom:tabBar arrowDirection:UIPopoverArrowDirectionUp];
        NSLog(@"showFromTabBar exception!");
    }
    @finally
    {
        _showHandler = @selector(showFromTabBar:);
        _showParam = tabBar;
    }
}

- (void)showInView:(UIView *)view
{   
    @try
    {
        [[self createActionSheet] showInView:view];
        NSLog(@"showInView done!");
    }
    @catch (NSException *exception)
    {
        [self showInRootViewFrom:view arrowDirection:UIPopoverArrowDirectionUnknown];
        NSLog(@"showInView exception!");
    }
    @finally
    {
        _showHandler = @selector(showInView:);
        _showParam = view;
    }
}

- (void)doPopoverFromBarButtonItem:(UIBarButtonItem *)button
{
    UIView *buttonView = [button performSelector:@selector(view)];
    [self showInRootViewFrom:buttonView arrowDirection:UIPopoverArrowDirectionUp];
}

- (void)popoverFromBarButtonItem:(UIBarButtonItem *)button
{
    [self createActionSheet];
    
    [self doPopoverFromBarButtonItem:button];
    
    _showHandler = @selector(popoverFromBarButtonItem:);
    _showParam = button;
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)button
{
//    @try
//    {
//        [[self createActionSheet] showFromBarButtonItem:button animated:YES];
//    }
//    @catch (NSException *exception)
//    {
//        [self doPopoverFromBarButtonItem:button];
//    }
//    @finally
//    {
//        _showHandler = @selector(showFromBarButtonItem:);
//        _showParam = button;
//    }
    
    [self popoverFromBarButtonItem:button];
}

@end
