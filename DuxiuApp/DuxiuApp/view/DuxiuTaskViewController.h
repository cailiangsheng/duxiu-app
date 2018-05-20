//
//  DuxiuTaskViewController.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DuxiuTaskViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *txtStat;
@property (weak, nonatomic) IBOutlet UITextView *txtLog;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tabButtons;

- (IBAction)onTaskViewClose:(id)sender;

- (IBAction)onTabSelect:(id)sender;
- (IBAction)onTaskAction:(id)sender;
- (IBAction)onTaskStop:(id)sender;

@end
