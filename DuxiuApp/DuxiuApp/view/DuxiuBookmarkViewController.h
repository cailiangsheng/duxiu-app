//
//  DuxiuBookmarkViewController.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DuxiuBookmarkViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *bookmarkTableView;

- (IBAction)onBookmarkViewClose:(id)sender;

@end
