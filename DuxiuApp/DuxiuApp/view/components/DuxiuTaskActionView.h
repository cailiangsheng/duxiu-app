//
//  DuxiuTaskActionView.h
//  DuxiuDown
//
//  Created by 良胜 蔡 on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DuxiuTaskActionView : NSObject

+ (DuxiuTaskActionView *)instance;

- (BOOL)dismiss;
- (void)showInView:(UIView *)view;
- (void)showFromTabBar:(UITabBar *)tabBar;
- (void)showFromBarButtonItem:(UIBarButtonItem *)button;

@end
