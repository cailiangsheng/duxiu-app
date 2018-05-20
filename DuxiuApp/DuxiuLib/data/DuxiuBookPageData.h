//
//  DuxiuBookPageData.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

@interface DuxiuBookPageData : NSObject

@property (copy) NSString *pageName;
@property (strong) NSMutableData *pageBytes;

- (DuxiuBookPageData *)initWithPageName:(NSString *)pageName pageByte:(NSMutableData *)pageBytes;

@end
