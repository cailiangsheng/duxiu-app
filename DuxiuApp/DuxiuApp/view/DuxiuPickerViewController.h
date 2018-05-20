//
//  DuxiuPickerViewController.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EVENT_PICKERVIEW_SELECTED @"eventPickViewSelected"

@interface DuxiuPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) NSArray *dataProvider;
@property (copy) NSString *selectedLabel;
@property (copy) NSString *headerTitle;

@property (weak, nonatomic) IBOutlet UITableView *pickerTableView;

- (IBAction)onPickerViewClose:(id)sender;

@end
