//
//  ISigmaHtmlVarSearcher.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-8.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISigmaHtmlVarSearchDelegate <NSObject>

- (void)onSearchComplete;
- (void)onSearchError;

@end

@protocol ISigmaHtmlVarSearcher <NSObject>

- (BOOL)searchVarWithURL:(NSString *)url andNameList:(NSString *)varName, ...;
- (BOOL)searchVarWithURL:(NSString *)url andNames:(NSArray *)varNames;
- (BOOL)searchVarWithURL:(NSString *)url andName:(NSString *)varName;

- (NSString *)getVarPropWithName:(NSString *)propName;
- (NSString *)getVarPropWithName:(NSString *)propName isReplaceFromHome:(BOOL)rfh;
- (NSString *)getVarPropWithName:(NSString *)propName isReplaceFromHome:(BOOL)rfh isDocumentProp:(BOOL)dp;

- (void)setDelegate:(id<ISigmaHtmlVarSearchDelegate>)delegate;

@end
