//
//  DuxiuBrowseViewController.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuBrowseViewController.h"

#import "SigmaWebView.h"

#import "DuxiuModel.h"
#import "DuxiuController.h"

@interface DuxiuBrowseViewController ()

@property (strong) SigmaWebView *webView;

@end

@implementation DuxiuBrowseViewController

@synthesize clientView;

@synthesize webView = _webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _webView = [[SigmaWebView alloc] init];
    [_webView showInView:self.clientView];
    
    // initialize
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWebViewBrowse) name:EVENT_WEBVIEW_BROWSE object:_webView];
}

- (void)viewDidLayoutSubviews
{
    [_webView resize:self.clientView.frame];
}

- (void)viewDidUnload
{
    [self setClientView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    // finalize
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_WEBVIEW_BROWSE object:_webView];
    [self setWebView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

//------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
{
    // activate
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationChange) name:EVENT_MODEL_BROWSE_LOCATION_CHANGE object:nil];
    
    [self onLocationChange];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //deacitvate
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_BROWSE_LOCATION_CHANGE object:nil];
}

- (void)onLocationChange
{
    [_webView navigateToURL:[DuxiuModel instance].browseModel.location];
}

- (void)onWebViewBrowse
{
    [[DuxiuController instance] onBrowse:_webView.currentURL];
}

- (IBAction)onBrowseAction:(id)sender {
    [_webView showTextInput];
}

- (IBAction)onNavigateAction:(id)sender {
    [_webView showMenu];
}
@end
