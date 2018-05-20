//
//  DuxiuBookPageRange.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

@interface DuxiuBookPageRange : NSObject

- (DuxiuBookPageRange *)initWithPageTypeName:(NSString *)pageTypeName;
- (void)reset;
- (void)sort;
- (BOOL)addPageByName:(NSString *)pageName;
- (NSString *)pageTypeName;
- (int)total;
- (int)minNo;
- (int)maxNo;
- (BOOL)isSequential;
- (int)numMissings;
- (int)numOriginRenamed;
- (int)numOrderRenamed;
- (NSArray *)missings;
- (NSString *)description;

@end
