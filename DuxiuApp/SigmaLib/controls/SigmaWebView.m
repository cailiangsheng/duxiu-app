//
//  SigmaWebView.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SigmaWebView.h"

#import "SigmaBrowserUtil.h"

#import "SigmaViewControllerUtil.h"

@interface SigmaWebView () <UIWebViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (strong) UIWebView *webView;
@property (nonatomic) NSString *loadingURL;
@property (nonatomic) NSString *targetURL;

@property (nonatomic) NSString *checkingURL;

@property (strong) UIActivityIndicatorView *progressView;

@property (strong) UIActionSheet *actionSheet;
@property (nonatomic) SEL showHandler;
@property (nonatomic) id showParam;

@property (strong) UIAlertView *alertView;

- (void)beginLoading:(NSString *)loading;
- (void)endLoading:(BOOL)error;
- (void)stopLoading;

- (BOOL)isProgressShowing;
- (void)showProgressWithError:(BOOL)error;
- (void)hideProgressWithMessage:(NSString *)message isError:(BOOL)error;

@end

@implementation SigmaWebView

@synthesize webView = _webView;
@synthesize loadingURL = _loadingURL;
@synthesize targetURL = _targetURL;

@synthesize checkingURL = _checkingURL;
@synthesize progressView = _progressView;

@synthesize actionSheet = _actionSheet;
@synthesize showHandler = _showHandler;
@synthesize showParam = _showParam;

@synthesize alertView = _alertView;

- (UIWebView *)webView
{
    if (_webView == nil)
    {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        [self resize:self.frame];
        [self addSubview:_webView];
    }
    return _webView;
}

- (UIActivityIndicatorView *)progressView
{
    if (_progressView == nil)
    {
        _progressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self resize:self.frame];
    }
    return _progressView;
}

- (BOOL)isLoading
{
    return _loadingURL != nil || (_webView && _webView.loading);
}

- (NSString *)targetURL
{
    return _targetURL;
}

- (NSString *)currentURL
{
    return _webView ? _webView.request.URL.absoluteString : nil;
}

- (NSString *)loadingURL
{
    return _loadingURL;
}

- (void)navigateToURL:(NSString *)url
{
    url = [SigmaBrowserUtil getHttpUrl:url];
    
    if (![self.targetURL isEqualToString:url] && 
        ![self.currentURL isEqualToString:url] && 
        ![self.loadingURL isEqualToString:url])
    {
        _targetURL = url;
        
        [self beginLoading:url];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self.webView loadRequest:request];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self endLoading:false];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _targetURL = nil;
    
    if (error.code == -999)
    {
        NSLog(@"The previous url request of UIWebView is canceled!");
        [self endLoading:false];
    }
    else
    {
        [self endLoading:true];
    }
}

// LocationChangeEvent
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *newLocation = request.URL.absoluteString;
    if (![SigmaBrowserUtil compareURL:newLocation withURL:[self currentURL]])
    {
        [self beginLoading:newLocation];
    }
    return YES;
}

- (void)checkLocationChanged
{
    if (![_checkingURL isEqualToString:self.currentURL])
    {
        _checkingURL = self.currentURL;
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_WEBVIEW_BROWSE object:self];
    }
}

- (void)beginLoading:(NSString *)loading
{
    _loadingURL = loading;
    [self showProgressWithError:false];
    
    [self checkLocationChanged];
}

- (void)endLoading:(BOOL)error
{
    _loadingURL = nil;
    [self showProgressWithError:error];
    
    [self checkLocationChanged];
    
    [self refreshMenu];
}

- (void)showInView:(UIView *)view
{
    if (view)
        [view addSubview:self];
    
    if ([self isLoading])
        [self showProgressWithError:false];
}

- (void)hide
{
    [self hideProgressWithMessage:nil isError:false];
    
    [self removeFromSuperview];
}

- (void)resize:(CGRect)rect
{
    self.frame = rect;
    self.webView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
    CGRect center = self.progressView.frame;
    center.origin.x = (rect.size.width - center.size.width) / 2;
    center.origin.y = (rect.size.height - center.size.height) / 2;
    self.progressView.frame = center;
}

//----------------------------------------------------
- (BOOL)isProgressShowing
{
    return _progressView && _progressView.superview;
}

- (void)showProgressWithError:(BOOL)error
{
    if (error)
    {
        [self hideProgressWithMessage:@"加载出错" isError:true];
    }
    else if (self.isLoading)
    {
        if (!self.isProgressShowing)
        {
            [self addSubview:self.progressView];
            [self.progressView startAnimating];
        }
    }
    else
    {
        [self hideProgressWithMessage:@"加载完毕" isError:false];
    }
}

- (void)hideProgressWithMessage:(NSString *)message isError:(BOOL)error
{
    if (_progressView)
    {
        [_progressView stopAnimating];
        [_progressView removeFromSuperview];
    }
    
    if (error)
    {
        [[[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

//----------------------------------------------------
- (void)refreshMenu
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
        [self dismissMenuAnimated:YES];
    }
}

- (void)dismissMenu
{
    
    [self dismissMenuAnimated:NO];
}

- (void)dismissMenuAnimated:(BOOL)animated
{
    if (_actionSheet)
    {
        [_actionSheet dismissWithClickedButtonIndex:_actionSheet.cancelButtonIndex animated:animated];
        _actionSheet = nil;
        _showHandler = nil;
        _showParam = nil;
    }
}

- (UIActionSheet *)createActionSheet
{
    // dismiss
    [self dismissMenu];
    
    // create
    _actionSheet = [[UIActionSheet alloc] init];
    //_actionSheet.title = self.currentURL;
    _actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    _actionSheet.delegate = self;
    
    [_actionSheet addButtonWithTitle:@"刷新"];
    
    if (self.isLoading)
        [_actionSheet addButtonWithTitle:@"停止"];
    
    if (self.webView.canGoForward)
        [_actionSheet addButtonWithTitle:@"前进"];
    
    if (self.webView.canGoBack)
        [_actionSheet addButtonWithTitle:@"后退"];
    
    [_actionSheet addButtonWithTitle:@"取消"];
    
    _actionSheet.destructiveButtonIndex = 0;
    _actionSheet.cancelButtonIndex = _actionSheet.numberOfButtons - 1;
    return _actionSheet;
}

- (void)showMenu
{
    [[self createActionSheet] showInView:self];
    
    _showHandler = @selector(showMenu);
    _showParam = nil;
}

- (void)showMenuInView:(UIView *)view
{
    [[self createActionSheet] showInView:view];
    
    _showHandler = @selector(showInView:);
    _showParam = view;
}

- (void)showMenuFromBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [[self createActionSheet] showFromBarButtonItem:barButtonItem animated:YES];
    
    _showHandler = @selector(showMenuFromBarButtonItem:);
    _showParam = barButtonItem;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissMenu];
    
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"刷新"])
    {
        [self beginLoading:self.currentURL];
        [self.webView reload];
    }
    else if ([title isEqualToString:@"停止"])
    {
        [self.webView stopLoading];
    }
    else if ([title isEqualToString:@"前进"])
    {
        [self.webView goForward];
    }
    else if ([title isEqualToString:@"后退"])
    {
        [self.webView goBack];
    }
    
    [self checkLocationChanged];
}

//----------------------------------------------------
- (UIAlertView *)alertView
{
    if (_alertView == nil)
    {
        _alertView = [[UIAlertView alloc] initWithTitle:@"浏览地址" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        _alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        _alertView.delegate = self;
        self.alertTextField.placeholder = @"编辑前往此地址";
        self.alertTextField.keyboardType = UIKeyboardTypeURL;
        self.alertTextField.returnKeyType = UIReturnKeyGo;
        self.alertTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.alertTextField.delegate = self;
    }
    return _alertView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.alertView dismissWithClickedButtonIndex:1 animated:YES];
    return YES;
}

- (UITextField *)alertTextField
{
    return [self.alertView textFieldAtIndex:0];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
    if ([button isEqualToString:@"确定"])
    {
        [self navigateToURL:self.alertTextField.text];
    }
}

- (void)showTextInput
{
    self.alertTextField.text = self.currentURL;
    [self.alertView show];
}

@end
