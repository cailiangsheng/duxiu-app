//
//  DuxiuBookmarkViewController.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuBookmarkViewController.h"

#import "SigmaViewControllerUtil.h"

#import "DuxiuModel.h"

@interface DuxiuBookmarkViewController ()

@end

@implementation DuxiuBookmarkViewController

@synthesize bookmarkTableView;

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
    
    self.bookmarkTableView.dataSource = self;
    self.bookmarkTableView.delegate = self;
}

- (void)viewDidUnload
{
    [self setBookmarkTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (IBAction)onBookmarkViewClose:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

//---------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [DuxiuModel instance].browseModel.bookmarks.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[DuxiuModel instance].browseModel.bookmarks objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSArray *list = [[DuxiuModel instance].browseModel.bookmarks objectAtIndex:indexPath.section];
    DuxiuBrowseItem *item = [list objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.httpUrl;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *list = [[DuxiuModel instance].browseModel.bookmarks objectAtIndex:indexPath.section];
    DuxiuBrowseItem *item = [list objectAtIndex:indexPath.row];
    [DuxiuModel instance].browseModel.location = item.url;
    
    [SigmaViewControllerUtil dismissViewController:self animated:YES];
}

@end
