//
//  DuxiuTaskViewController.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuTaskViewController.h"

#import "DuxiuPickerViewController.h"
#import "DuxiuTaskActionView.h"

#import "DuxiuBookPageDefine.h"
#import "DuxiuModel.h"
#import "DuxiuController.h"

#import "SigmaViewControllerUtil.h"

@interface DuxiuTaskViewController ()

@property (weak, nonatomic) UITextField *txtTitle;
@property (weak, nonatomic) UITextField *txtSSNO;
@property (weak, nonatomic) UITextField *txtSTR;
@property (weak, nonatomic) UITextField *txtSPage;
@property (weak, nonatomic) UITextField *txtEPage;
@property (weak, nonatomic) UITextField *txtSaveHome;
@property (weak, nonatomic) UILabel *txtPageZoom;
@property (weak, nonatomic) UILabel *txtPageType;
@property (weak, nonatomic) UITextField *txtFromPage;
@property (weak, nonatomic) UITextField *txtToPage;

@property (weak, nonatomic) UITextField *txtFocus;

- (void)onKeyboardSlide:(NSNotification *)notifycation;

@end

static NSMutableArray *_pageZooms = nil;
static NSMutableArray *_pageTypes = nil;

@implementation DuxiuTaskViewController

@synthesize tableView;
@synthesize txtStat;
@synthesize txtLog;
@synthesize tabButtons = _tabButtons;

@synthesize txtTitle = _txtTitle;
@synthesize txtSSNO = _txtSSNO;
@synthesize txtSTR = txtSTR;
@synthesize txtSPage = _txtSPage;
@synthesize txtEPage = _txtEPage;
@synthesize txtSaveHome = _txtSaveHome;
@synthesize txtPageZoom = _txtPageZoom;
@synthesize txtPageType = _txtPageType;
@synthesize txtFromPage = _txtFromPage;
@synthesize txtToPage = _txtToPage;

@synthesize txtFocus = _txtFocus;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc: %@", self);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardSlide:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardSlide:) name:UIKeyboardWillHideNotification object:self.view.window];
    
    // initialize
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDownloadBegin) name:EVENT_MODEL_DOWNLOAD_BEGIN object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPageCountChange) name:EVENT_MODEL_PAGECOUNT_CHAGNE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onExportBegin) name:EVENT_MODEL_EXPORT_BEGIN object:nil];
}

- (void)viewDidUnload
{
    [self setTxtStat:nil];
    [self setTxtLog:nil];
    [self setTableView:nil];
    
    [self setTxtTitle:nil];
    [self setTxtSSNO:nil];
    [self setTxtSTR:nil];
    [self setTxtSPage:nil];
    [self setTxtEPage:nil];
    [self setTxtSaveHome:nil];
    [self setTxtPageType:nil];
    [self setTxtPageZoom:nil];
    [self setTxtFromPage:nil];
    [self setTxtToPage:nil];
    [self setTabButtons:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:self.view.window];
    
    // finalize
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_DOWNLOAD_BEGIN object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_PAGECOUNT_CHAGNE object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_EXPORT_BEGIN object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    // activate
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBookTitleChange) name:EVENT_MODEL_BOOKTITLE_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBookSSNoChange) name:EVENT_MODEL_BOOKSSNO_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBookSTRChange) name:EVENT_MODEL_BOOKSTR_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBookSPageChange) name:EVENT_MODEL_BOOKSPAGE_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBookEPageChange) name:EVENT_MODEL_BOOKEPAGE_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSaveHomeChange) name:EVENT_MODEL_SAVEHOME_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPageZoomChange) name:EVENT_MODEL_PAGEZOOM_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPageTypeChange) name:EVENT_MODEL_PAGETYPE_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFromPageChange) name:EVENT_MODEL_FROMPAGE_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onToPageChange) name:EVENT_MODEL_TOPAGE_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogChange) name:EVENT_MODEL_LOG_CHANGE object:nil];
    
    [self onBookTitleChange];
    [self onBookSSNoChange];
    [self onBookSTRChange];
    [self onBookSPageChange];
    [self onBookEPageChange];
    [self onSaveHomeChange];
    [self onPageZoomChange];
    [self onPageTypeChange];
    [self onFromPageChange];
    [self onToPageChange];
    
    [self onLogChange];
    
    [self onPageCountChange];
    
    [self updateSize];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // deactivate
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_BOOKTITLE_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_BOOKSSNO_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_BOOKSTR_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_BOOKSPAGE_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_BOOKEPAGE_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_SAVEHOME_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_PAGEZOOM_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_PAGETYPE_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_FROMPAGE_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_TOPAGE_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_LOG_CHANGE object:nil];
    
    [self resetSizeWhenPopoverHide];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[DuxiuTaskActionView instance] dismiss];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)viewWillLayoutSubviews
{
    [self updateSize];
}

- (void)updateSize
{
    [self updateSize:self.txtTitle];
    [self updateSize:self.txtSSNO];
    [self updateSize:self.txtSTR];
    [self updateSize:self.txtSPage];
    [self updateSize:self.txtEPage];
    [self updateSize:self.txtSaveHome];
    [self updateSize:self.txtFromPage];
    [self updateSize:self.txtToPage];
    
    [self updateSize:self.txtPageZoom];
    [self updateSize:self.txtPageType];
    
    self.txtStat.frame = self.txtLog.frame = self.tableView.frame;
}

//..................................................................
// dirty codes for calculating client size

- (float)clientHeight
{
    float height = self.view.frame.size.height;
    
    if (self.navigationController == nil)
    {
        // ModalView for iPhone will rotate orientation, but SplitView-MasterView for iPad won't
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
            height = self.view.frame.size.width;
        }
        
        // iPhone: exist extra NavigationBar and ToolBar
        height -= 44 * 2;
    }
    return height;
}

- (float)clientWidth
{
    return self.tableView.frame.size.width;
}

//..................................................................
- (void)updateSize:(UIView *)view
{
    if (view == nil || self.clientWidth <= 0)
        return;
    
    // calculate delta
    double delta = self.clientWidth - 320;
    
    // resize
    if (view.class == [UITextField class])
    {
        CGRect textFrame = view.frame;
        textFrame.size.width = 205 + delta;
        view.frame = textFrame;
    }
    else if (view.class == [UILabel class])
    {
        CGRect labelFrame = view.frame;
        labelFrame.size.width = 200 + delta;
        view.frame = labelFrame;
    }
}

- (IBAction)onTaskViewClose:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)switchTab:(int)tabIndex
{
    [self.txtFocus resignFirstResponder];
    
    self.tableView.hidden = YES;
    self.txtStat.hidden = YES;
    self.txtLog.hidden = YES;
    switch (tabIndex) {
        case 0:
            self.tableView.hidden = NO;
            break;
        case 1:
            self.txtStat.hidden = NO;
            break;
        case 2:
            self.txtLog.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)showLogTab
{
    self.tabButtons.selectedSegmentIndex = 2;
    [self onTabSelect:self.tabButtons];
}

- (IBAction)onTabSelect:(id)sender
{
    [SigmaViewControllerUtil dismissAllPopoverAnimated:NO exceptViewController:self];
    
    UISegmentedControl *segments = (UISegmentedControl *)sender;
    [self switchTab:segments.selectedSegmentIndex];
}

- (IBAction)onTaskAction:(id)sender
{
    UIBarButtonItem *button = (UIBarButtonItem *)sender;
    [[DuxiuTaskActionView instance] showFromBarButtonItem:button];
}

- (IBAction)onTaskStop:(id)sender {
    [[DuxiuController instance] onStopAll];
}

//------------------------------------------------
NSMutableArray *getPageZooms()
{
    if (_pageZooms == nil)
    {
        _pageZooms = [[NSMutableArray alloc] init];
        for (DuxiuBookPageZoom *zoom in [DuxiuBookPageDefine pageZooms]) {
            [_pageZooms addObject:zoom.zoomName];
        }
    }
    return _pageZooms;
}

NSMutableArray *getPageTypes()
{
    if (_pageTypes == nil)
    {
        _pageTypes = [[NSMutableArray alloc] init];
        for (DuxiuBookPageType *type in [DuxiuBookPageDefine pageTypes]) {
            [_pageTypes addObject:type.typeName];
        }
    }
    return _pageTypes;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [SigmaViewControllerUtil dismissAllPopoverAnimated:NO exceptViewController:self];
    
    DuxiuPickerViewController *picker = (DuxiuPickerViewController *)segue.destinationViewController;
    UITableViewCell *cell = (UITableViewCell *)sender;
    if ([segue.identifier isEqualToString:@"pickPageZoom"])
    {
        cell.selected = false;
        
        picker.dataProvider = getPageZooms();
        picker.selectedLabel = self.txtPageZoom.text;
        picker.headerTitle = @"图尺寸:";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPageZoomEdit:) name:EVENT_PICKERVIEW_SELECTED object:picker];
    }
    else if ([segue.identifier isEqualToString:@"pickPageType"])
    {
        cell.selected = false;
        
        picker.dataProvider = getPageTypes();
        picker.selectedLabel = self.txtPageType.text;
        picker.headerTitle = @"页类型:";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPageTypeEdit:) name:EVENT_PICKERVIEW_SELECTED object:picker];
    }
}

- (void)onPageZoomEdit:(NSNotification *)notification
{
    DuxiuPickerViewController *picker = notification.object;
    [[DuxiuController instance] onPageZoomEdit:picker.selectedLabel];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_PICKERVIEW_SELECTED object:picker];
}

- (void)onPageTypeEdit:(NSNotification *)notification
{
    DuxiuPickerViewController *picker = notification.object;
    [[DuxiuController instance] onPageTypeEidt:picker.selectedLabel];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_PICKERVIEW_SELECTED object:picker];
}

//------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"任务参数:";
        case 1:
            return @"下载配置:";
        default:
            break;
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 5;
        case 1:
            return 5;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell[%ld,%ld]", indexPath.section, indexPath.row];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selected = false;
    [self fetchFieldFromCell:cell atIndexPath:indexPath];
    return cell;
}

//------------------------------------------------
- (void)fetchFieldFromCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    UIView *contentView = [[cell subviews] objectAtIndex:0];
    if (contentView.class != NSClassFromString(@"UITableViewCellContentView"))
    {
        return;
    }
    
    UIView *field = [[contentView subviews] objectAtIndex:1];
    UILabel *label = (UILabel *)field;
    UITextField *textField = (UITextField *)field;
    
    if (textField.class == UITextField.class)
    {
        textField.delegate = self;
    }
    
    [self updateSize:field];
    
    switch (indexPath.section)
    {
        case 0:
            switch (indexPath.row)
            {
                case 0:
                    self.txtTitle = textField;
                    [self onBookTitleChange];
                    break;
                case 1:
                    self.txtSSNO = textField;
                    [self onBookSSNoChange];
                    break;
                case 2:
                    self.txtSTR = textField;
                    [self onBookSTRChange];
                    break;
                case 3:
                    self.txtSPage = textField;
                    [self onBookSPageChange];
                    break;
                case 4:
                    self.txtEPage = textField;
                    [self onBookEPageChange];
                    break;
            }
            break;
        case 1:
            switch (indexPath.row)
            {
                case 0:
                    self.txtSaveHome = textField;
                    [self onSaveHomeChange];
                    break;
                case 1:
                    self.txtPageZoom = label;
                    [self onPageZoomChange];
                    break;
                case 2:
                    self.txtPageType = label;
                    [self onPageTypeChange];
                    break;
                case 3:
                    self.txtFromPage = textField;
                    [self onFromPageChange];
                    break;
                case 4:
                    self.txtToPage = textField;
                    [self onToPageChange];
                    break;
                default:
                    break;
            }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return [self isTextFieldEnabled:textField];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _txtFocus = textField;
    
    [self scrollTableViewToFocus:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _txtFocus = nil;
    
    // TextField Edited
    if (textField == self.txtTitle)
    {
        [[DuxiuController instance] onBookTitleEdit:textField.text];
    }
    else if (textField == self.txtSPage)
    {
        [[DuxiuController instance] onBookSPageEdit:textField.text];
    }
    else if (textField == self.txtEPage)
    {
        [[DuxiuController instance] onBookEPageEdit:textField.text];
    }
    else if (textField == self.txtSaveHome)
    {
        [[DuxiuController instance] onSaveHomeEdit:textField.text];
    }
}

- (void)scrollTableViewToFocus:(BOOL)animated
{
    CGPoint ptTextField = [_txtFocus convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath= [self.tableView indexPathForRowAtPoint:ptTextField];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:animated];
}

- (void)resetSizeWhenPopoverHide
{
    if (self.navigationController == nil ||
        self.navigationController.topViewController == self)
    {
        [self resetSize];
    }
}

- (void)resetSize
{
    CGRect originFrame = self.tableView.frame;
    originFrame.size.height = self.clientHeight;
    self.txtStat.frame = self.txtLog.frame = self.tableView.frame = originFrame;
}

- (void)onKeyboardSlide:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    NSNumber *number = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    double duration = number.doubleValue;
    
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = value.CGRectValue;
    
    CGRect rectKeyboard = [self.view.window convertRect:rect toView:self.view];
    if (rectKeyboard.size.height <= 0 ||
        rectKeyboard.origin.x >= self.clientWidth ||
        [SigmaViewControllerUtil getPopoverControllerWithView:self.view])
    {
        [self resetSize];
        return;
    }
    
    float viewBottom = self.view.frame.origin.y + self.view.frame.size.height;
    rectKeyboard.origin.y = MIN(rectKeyboard.origin.y, viewBottom);
    
    int tableBottom = self.tableView.frame.origin.y + self.tableView.frame.size.height;
    int deltaY = rectKeyboard.origin.y - tableBottom;
    if (deltaY != 0)
    {
        CGRect viewFrame = self.tableView.frame;
        viewFrame.size.height += deltaY;
        viewFrame.size.height = MIN(viewFrame.size.height, self.clientHeight);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:duration];
        
        self.txtStat.frame = self.txtLog.frame = self.tableView.frame = viewFrame;
        [self scrollTableViewToFocus:NO];
        
        [UIView commitAnimations];
    }
}

//------------------------------------------------
- (BOOL)isTextFieldEnabled:(UITextField *)textField
{
    if (textField == self.txtSSNO)
    {
        return false;
    }
    else if (textField == self.txtFromPage || 
             textField == self.txtToPage)
    {
        return textField.text.length > 0;
    }
    return [DuxiuModel instance].taskModel.canFetchParams || 
           [DuxiuModel instance].taskModel.canStartDownload || 
           [DuxiuModel instance].taskModel.canStartExport;
}

NSString *getText(id value, NSString *placeHolder)
{
    return value == nil || [value length] == 0 ? placeHolder : [NSString stringWithFormat:@"%@", value];
}

NSString *getText2(id value)
{
    return getText(value, @"未定义");
}

- (void)onBookTitleChange
{
    if (self.txtTitle)
        self.txtTitle.text = getText2([DuxiuModel instance].taskModel.bookTitle);
}

- (void)onBookSSNoChange
{
    if (self.txtSSNO)
        self.txtSSNO.text = getText2([DuxiuModel instance].taskModel.bookSSNo);
}

- (void)onBookSTRChange
{
    if (self.txtSTR)
        self.txtSTR.text = getText2([DuxiuModel instance].taskModel.bookSTR);
}

- (void)onBookSPageChange
{
    if (self.txtSPage)
        self.txtSPage.text = getText2([DuxiuModel instance].taskModel.startPage);
}

- (void)onBookEPageChange
{
    if (self.txtEPage)
        self.txtEPage.text = getText2([DuxiuModel instance].taskModel.endPage);
}

- (void)onSaveHomeChange
{
    if (self.txtSaveHome)
        self.txtSaveHome.text = getText2([DuxiuModel instance].taskModel.saveHome);
}

- (void)onPageZoomChange
{
    self.txtPageZoom.text = getText2([DuxiuModel instance].taskModel.pageZoom);
}

- (void)onPageTypeChange
{
    self.txtPageType.text = getText2([DuxiuModel instance].taskModel.pageType);
}

- (void)onFromPageChange
{
    if (self.txtFromPage)
    {
        if ([DuxiuModel instance].taskModel.fromPage == nil)
        {
            self.txtFromPage.text = @"";
        }
        else
        {
            self.txtFromPage.text = [DuxiuModel instance].taskModel.fromPage.stringValue;
        }
    }
}

- (void)onToPageChange
{
    if (self.txtToPage)
    {
        if ([DuxiuModel instance].taskModel.toPage == nil)
        {
            self.txtToPage.text = @"";
        }
        else
        {
            self.txtToPage.text = [DuxiuModel instance].taskModel.toPage.stringValue;
        }
    }
}

- (void)onLogChange
{
    self.txtLog.text = getText([DuxiuModel instance].taskModel.log, @"尚无日志");
    
    // scroll to bottom
    int bottomOffset = MAX(0, self.txtLog.contentSize.height - self.txtLog.bounds.size.height);
    self.txtLog.contentOffset = CGPointMake(0, bottomOffset);
}

- (void)onDownloadBegin
{
    [self showLogTab];
}

- (void)onPageCountChange
{
    self.txtStat.text = [DuxiuModel instance].taskModel.countModel.counter.description;
}

- (void)onExportBegin
{
    [self showLogTab];
}



@end
