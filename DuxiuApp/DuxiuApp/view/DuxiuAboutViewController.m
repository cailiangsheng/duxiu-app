//
//  DuxiuAboutViewController.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuAboutViewController.h"

#import "SigmaBrowserUtil.h"

@interface DuxiuAboutViewController ()

@end

@implementation DuxiuAboutViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.detailTextLabel.text hasPrefix:@"http://"])
    {
        cell.selected = false;
        [SigmaBrowserUtil navigateToURL:cell.detailTextLabel.text];
    }
}

@end
