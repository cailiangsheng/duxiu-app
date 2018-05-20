//
//  DuxiuBookPageIterator.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuTaskModel.h"

#import "DuxiuBookPageType.h"

@interface DuxiuBookPageIterator : NSObject

- (DuxiuBookPageIterator *)initWithTaskModel:(DuxiuTaskModel *)taskModel;
- (void)dispose;
- (DuxiuBookPageType *)curPageType;
- (int)curPageNumber;
- (BOOL)isValid;
- (void)setPageType:(NSString *)pageType;
- (BOOL)nextPageNumber;
- (BOOL)nextPageType;

@end
