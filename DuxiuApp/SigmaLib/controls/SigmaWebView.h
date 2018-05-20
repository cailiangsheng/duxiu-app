//
//  SigmaWebView.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EVENT_WEBVIEW_BROWSE @"eventWebViewLocationChange"

@interface SigmaWebView : UIView

- (BOOL)isLoading;
- (NSString *)targetURL;
- (NSString *)currentURL;
- (NSString *)loadingURL;

- (void)navigateToURL:(NSString *)url;

- (void)showInView:(UIView *)view;
- (void)hide;
- (void)resize:(CGRect)rect;

- (void)dismissMenu;
- (void)showMenu;
- (void)showMenuInView:(UIView *)view;
- (void)showMenuFromBarButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)showTextInput;


@end
