//
//  SigmaBaseHtmlVarSearcher.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-8.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ISigmaHtmlVarSearcher.h"

@interface SigmaBaseHtmlVarSearcher : NSObject <ISigmaHtmlVarSearcher>

@property (strong) NSMutableDictionary *defaultWindow;
@property (strong) NSArray *searchVarNames;
@property (strong) NSMutableDictionary *searchFrames;
@property (nonatomic) int searchNumFrames;
@property (strong) NSMutableDictionary *searchedWindow;

@property (strong) id<ISigmaHtmlVarSearchDelegate> delegate;

- (void)doSearchVar;
- (void)onSearchedWindow:(id)window;
- (void)stopSearch;
- (void)doSearchFrames;

@end
