//
//  DuxiuPickerViewController.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuPickerViewController.h"

#import "SigmaViewControllerUtil.h"

@interface DuxiuPickerViewController ()

@end

@implementation DuxiuPickerViewController

@synthesize pickerTableView;

@synthesize dataProvider = _dataProvider;
@synthesize selectedLabel = _selectedLabel;
@synthesize headerTitle = _headerTitle;

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
    
    self.pickerTableView.dataSource = self;
    self.pickerTableView.delegate = self;
}

- (void)viewDidUnload
{
    [self setPickerTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.dataProvider = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (IBAction)onPickerViewClose:(id)sender {
    [SigmaViewControllerUtil dismissViewController:self animated:YES];
}

//---------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataProvider)
        return 1;
    else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataProvider.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _headerTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selected = false;
    
    if (_dataProvider)
        cell.textLabel.text = [_dataProvider objectAtIndex:indexPath.row];
    else
        cell.textLabel.text = @"";
    
    if ([_selectedLabel isEqualToString:cell.textLabel.text])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedLabel = cell.textLabel.text;
    
    [SigmaViewControllerUtil dismissViewController:self animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_PICKERVIEW_SELECTED object:self];
}

@end
