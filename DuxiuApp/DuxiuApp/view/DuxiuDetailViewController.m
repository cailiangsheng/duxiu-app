//
//  DuxiuDetailViewController.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuDetailViewController.h"

#import "SigmaWebView.h"
#import "SigmaViewControllerUtil.h"

#import "DuxiuModel.h"
#import "DuxiuController.h"

#import "DuxiuAboutViewController.h"

@interface DuxiuDetailViewController () <UISearchBarDelegate>

@property (strong) UIBarButtonItem *btnMaster;

@property (strong) SigmaWebView *webView;

@property (strong) UIStoryboardSegue *segue;

@end

@implementation DuxiuDetailViewController

@synthesize titleBar;
@synthesize searchBar;
@synthesize toolBar;

@synthesize btnMaster = _btnMaster;

@synthesize webView = _webView;

@synthesize segue = _segue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UISplitViewController *splitViewController = (UISplitViewController *)self.parentViewController;
    splitViewController.delegate = self;
    
    self.searchBar.delegate = self;
    
    _webView = [[SigmaWebView alloc] init];
    [_webView showInView:self.view];
    
    // initialize
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWebViewBrowse) name:EVENT_WEBVIEW_BROWSE object:_webView];
}

- (void)viewDidUnload
{
    [self setTitleBar:nil];
    [self setSearchBar:nil];
    [self setToolBar:nil];
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    _segue = [SigmaViewControllerUtil reperformSegue:_segue];
}

- (void)viewWillLayoutSubviews
{
    [self updateLayout];
}

- (void)updateLayout
{
    CGRect rect = self.titleBar.frame;
    rect.size.width = 163;
    self.titleBar.frame = rect;
    
    rect = self.toolBar.frame;
    rect.size.width = 99;
    rect.origin.x = self.view.frame.size.width - rect.size.width;
    self.toolBar.frame = rect;
    
    rect = self.searchBar.frame;
    rect.origin.x = self.titleBar.frame.origin.x + self.titleBar.frame.size.width;
    rect.size.width = self.toolBar.frame.origin.x - rect.origin.x;
    
    rect = self.view.frame;
    rect.origin.x = 0;
    rect.origin.y = self.titleBar.frame.origin.x + self.titleBar.frame.size.height;
    rect.size.height -= rect.origin.y;
    [_webView resize:rect];
}

- (void)viewDidAppear:(BOOL)animated
{
    // activate
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationChange) name:EVENT_MODEL_BROWSE_LOCATION_CHANGE object:nil];
    
    [self onLocationChange];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // deactivate
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_BROWSE_LOCATION_CHANGE object:nil];
}

- (void)onLocationChange
{
    [_webView navigateToURL:[DuxiuModel instance].browseModel.location];
}

- (void)onWebViewBrowse
{
    [[DuxiuController instance] onBrowse:_webView.currentURL];
    self.searchBar.text = _webView.currentURL;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.searchBar.text = _webView.currentURL;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_webView navigateToURL:self.searchBar.text];
}

- (void)dismissAllPopover
{
    [SigmaViewControllerUtil dismissAllPopoverAnimated:NO exceptViewController:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self dismissAllPopover];
    
    _segue = segue;
}

- (IBAction)onNavigateAction:(id)sender
{
    [self dismissAllPopover];
    
    UIBarButtonItem *button = (UIBarButtonItem *)sender;
    [_webView showMenuFromBarButtonItem:button];
}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    _btnMaster = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    _btnMaster = nil;
}

- (IBAction)onShowMasterView:(id)sender
{
    if (_btnMaster && _btnMaster.action)
    {
        UISplitViewController *splitViewController = (UISplitViewController *)self.parentViewController;
        [splitViewController performSelector:_btnMaster.action];
    }
}

@end
