//
//  DuxiuHistoryViewController.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuHistoryViewController.h"

#import "SigmaViewControllerUtil.h"

#import "DuxiuModel.h"
#import "DuxiuController.h"

@interface DuxiuHistoryViewController ()

@property (strong) NSMutableArray *fileList;
@property (strong) NSMutableArray *dirList;

@property (strong) UIBarButtonItem *btnEdit;
@property (strong) UIBarButtonItem *btnEditDone;
@property (strong) UIBarButtonItem *btnDone;

@end

@implementation DuxiuHistoryViewController

@synthesize navigationBarContent = _navigationBarContent;
@synthesize tableView = _tableView;

@synthesize fileList = _fileList;
@synthesize dirList = _dirList;

@synthesize btnEdit = _btnEdit;
@synthesize btnEditDone = _btnEditDone;
@synthesize btnDone = _btnDone;

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _fileList = [[NSMutableArray alloc] init];
    _dirList = [[NSMutableArray alloc] init];
    
    _btnEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEditButtonAction:)];
    _btnEditDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onEditButtonAction:)];
    _btnDone = self.navigationBarContent.rightBarButtonItem;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setNavigationBarContent:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (IBAction)onHistoryViewClose:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)onEditButtonAction:(id)sender
{
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    [self checkEditState];
}

- (void)showButton:(UIBarButtonItem *)editButton doneButton:(UIBarButtonItem *)doneButton
{
    if (_btnDone)
    {
        self.navigationBarContent.leftBarButtonItem = editButton;
        self.navigationBarContent.rightBarButtonItem = doneButton;
    }
    else {
        self.navigationBarContent.rightBarButtonItem = editButton;
    }
}

- (void)checkEditState
{
    BOOL editable = (_dirList.count > 0 || _fileList.count > 0);
    if (editable)
    {
        if (self.tableView.isEditing)
            [self showButton:_btnEditDone doneButton:nil];
        else
            [self showButton:_btnEdit doneButton:_btnDone];
    }
    else
        [self showButton:nil doneButton:_btnDone];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateList];
    [self checkEditState];
}

- (void)updateList
{
    [_fileList removeAllObjects];
    [_dirList removeAllObjects];
    
    NSString *homePath = [DuxiuModel instance].taskModel.saveHome;
    NSArray *names = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:homePath error:nil];
    for (NSString *fileName in names)
    {
        BOOL isDir = NO;
        NSString *filePath = [homePath stringByAppendingPathComponent:fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir])
        {
            if (isDir)
            {
                [_dirList addObject:filePath];
            }
            else if ([[[filePath pathExtension] lowercaseString] isEqualToString:@"pdf"])
            {
                [_fileList addObject:filePath];
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0 ? _dirList : _fileList).count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section == 0 ? (_dirList.count > 0 ? @"历史任务:" : @"尚无任务") : 
                           (_fileList.count > 0 ? @"导出文件:" : @"尚未导出"));
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = nil;
    NSArray *list = nil;
    switch (indexPath.section)
    {
        case 0:
            cellId = @"CellTaskDirectory";
            list = _dirList;
            break;
        case 1:
            cellId = @"CellTaskFile";
            list = _fileList;
            break;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    NSString *filePath = [list objectAtIndex:indexPath.row];
    cell.textLabel.text = [filePath lastPathComponent];
    cell.selected = false;
    
    if (indexPath.section == 0)
    {
        if ([[DuxiuModel instance].taskModel.bookName isEqualToString:cell.textLabel.text])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            [[DuxiuController instance] onSelectDirPath:[_dirList objectAtIndex:indexPath.row]];
            [SigmaViewControllerUtil dismissViewController:self animated:YES];
            break;
        case 1:
            [[DuxiuController instance] onOpenFile:[_fileList objectAtIndex:indexPath.row]];
            break;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableArray *list = (indexPath.section == 0 ? _dirList : _fileList);
        NSString *filePath = [list objectAtIndex:indexPath.row];
        
        if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:nil])
        {
            // delete a row in the list data
            [list removeObjectAtIndex:indexPath.row];
            
            // delete a row will rebuild the tableview, so update the list data first
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            
            // check editable
            [self checkEditState];
        }
    }
}

@end
