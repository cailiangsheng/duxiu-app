//
//  SigmaViewControllerUtil.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-12.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SigmaViewControllerUtil.h"

@implementation SigmaViewControllerUtil

+ (UIViewController *)topModalViewControllerUntilClass:(Class)untilClass
{
    // keyWindow will be affected by the shown UIAlertView instances
    // and its rootViewController will be nil
    //    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    UIViewController *viewController = window.rootViewController;
    
    while (viewController.modalViewController && 
           viewController.modalViewController.class != untilClass)
    {
        viewController = viewController.modalViewController;
    }
    return viewController;
}

+ (UIViewController *)topModalViewController
{
    return [SigmaViewControllerUtil topModalViewControllerUntilClass:nil];
}

//---------------------------------------------------------------------------
UIPopoverController *getPopoverController(UIViewController *viewController)
{
    @try
    {
        return [viewController performSelector:@selector(_popoverController)];
    }
    @catch (NSException *exception)
    {
        return nil;
    }
    @finally
    {
    }
}

+ (UIPopoverController *)getPopoverController:(UIViewController *)viewController
{
    return getPopoverController(viewController);
}

+ (UIPopoverController *)getPopoverControllerWithView:(UIView *)view
{
    return getPopoverController([self getViewController:view]);
}

UIViewController *getViewController(UIView *view)
{
    @try
    {
        return [view performSelector:@selector(_viewDelegate)];
    }
    @catch (NSException *exception)
    {
        return nil;
    }
    @finally
    {
    }
}

+ (UIViewController *)getViewController:(UIView *)view
{
    return getViewController(view);
}

//---------------------------------------------------------------------------
int handlePopover(UIViewController *viewController, UIViewController *exceptViewController, Class forClass, void (^handler)(UIPopoverController *))
{
    if (viewController != exceptViewController &&
        viewController != exceptViewController.parentViewController &&
        (forClass == nil || viewController.class == forClass) &&
        getPopoverController(viewController))
    {
        UIPopoverController *popoverController = getPopoverController(viewController);
        if (handler && popoverController)
        {
            handler(popoverController);
        }
        return 1;
    }
    return 0;
}

int handlePopoverInViews(NSArray *views, UIViewController *exceptViewController, Class forClass, void (^handler)(UIPopoverController *))
{
    int count = 0;
    for (UIView *view in views)
    {
        if ([view performSelector:@selector(_viewDelegate)])
        {
            UIViewController *viewController = getViewController(view);
            count += handlePopover(viewController, exceptViewController, forClass, handler);
        }
        count += handlePopoverInViews(view.subviews, exceptViewController, forClass, handler);
    }
    return count;
}

int handleAllPopover(UIViewController *exceptViewController, Class forClass, void (^handler)(UIPopoverController *))
{
    int count = 0;
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        count += handlePopoverInViews(window.subviews, exceptViewController, forClass, handler);
    }
    return count > 0;
}

int dismissPopover(UIViewController *viewController, BOOL animated, UIViewController *exceptViewController, Class forClass)
{
    return handlePopover(viewController, exceptViewController, forClass, ^(UIPopoverController *popoverController)
                         {
                             [popoverController dismissPopoverAnimated:animated];
                         });
}

int dismissAllPopover(BOOL animated, UIViewController *exceptViewController, Class forClass)
{
    return handleAllPopover(exceptViewController, forClass, ^(UIPopoverController *popoverController)
                            {
                                [popoverController dismissPopoverAnimated:animated];
                            });
}

//---------------------------------------------------------------------------
+ (BOOL)dismissPopoverViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    return dismissPopover(viewController, animated, nil, nil) > 0;
}

+ (BOOL)dismissViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController)
    {
        if (viewController.navigationController && 
            viewController.navigationController.topViewController == viewController)
        {
            [viewController.navigationController popViewControllerAnimated:animated];
            return true;
        }
        else if ([SigmaViewControllerUtil topModalViewController] == viewController)
        {
            [viewController dismissModalViewControllerAnimated:animated];
            return true;
        }
        else
            return dismissPopover(viewController, animated, nil, nil) > 0;
    }
    return false;
}

+ (BOOL)dismissAllPopoverAnimated:(BOOL)animated exceptViewController:(UIViewController *)exceptViewController
{
    return dismissAllPopover(animated, exceptViewController, nil);
}

+ (BOOL)dismissAllPopoverAnimated:(BOOL)animated
{
    return [SigmaViewControllerUtil dismissAllPopoverAnimated:animated exceptViewController:nil];
}

+ (BOOL)dismissAllPopoverAnimated:(BOOL)animated forViewControllerClass:(Class)viewControllerClass
{
    return dismissAllPopover(animated, nil, viewControllerClass);
}

+ (UIStoryboardSegue *)reperformSegue:(UIStoryboardSegue *)segue
{
    if (segue &&
        [SigmaViewControllerUtil dismissAllPopoverAnimated:NO forViewControllerClass:[segue.destinationViewController class]])
    {
        [segue perform];
        return segue;
    }
    return nil;
}

@end
