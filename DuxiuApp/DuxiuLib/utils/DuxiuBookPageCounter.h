//
//  DuxiuBookPageCounter.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuBookPageRange.h"

@interface DuxiuBookPageCounter : NSObject

- (int)numPages;
- (int)numMissings;
- (int)numOriginRenamed;
- (int)numOrderRenamed;
- (NSString *)description;
- (BOOL)countAtDirPath:(NSString *)dirPath;

@end
