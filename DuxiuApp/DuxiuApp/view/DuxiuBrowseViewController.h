//
//  DuxiuBrowseViewController.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DuxiuBrowseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *clientView;

- (IBAction)onBrowseAction:(id)sender;

- (IBAction)onNavigateAction:(id)sender;

@end
