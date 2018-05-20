//
//  DuxiuHistoryViewController.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DuxiuHistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBarContent;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)onHistoryViewClose:(id)sender;

@end
