//
//  SigmaViewControllerUtil.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-12.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SigmaViewControllerUtil : NSObject

+ (UIViewController *)topModalViewController;
+ (UIViewController *)topModalViewControllerUntilClass:(Class)untilClass;

+ (BOOL)dismissViewController:(UIViewController *)viewController animated:(BOOL)animated;
+ (BOOL)dismissPopoverViewController:(UIViewController *)viewController animated:(BOOL)animated;

+ (UIViewController *)getViewController:(UIView *)view;
+ (UIPopoverController *)getPopoverController:(UIViewController *)viewController;
+ (UIPopoverController *)getPopoverControllerWithView:(UIView *)view;

+ (BOOL)dismissAllPopoverAnimated:(BOOL)animated;
+ (BOOL)dismissAllPopoverAnimated:(BOOL)animated exceptViewController:(UIViewController *)exceptViewController;
+ (BOOL)dismissAllPopoverAnimated:(BOOL)animated forViewControllerClass:(Class)viewControllerClass;

+ (UIStoryboardSegue *)reperformSegue:(UIStoryboardSegue *)segue;

@end
