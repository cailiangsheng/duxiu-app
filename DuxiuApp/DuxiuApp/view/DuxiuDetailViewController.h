//
//  DuxiuDetailViewController.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DuxiuDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *titleBar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *toolBar;

- (IBAction)onShowMasterView:(id)sender;

- (IBAction)onNavigateAction:(id)sender;

@end
