//
//  DuxiuBookPageData.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuBookPageData.h"

@implementation DuxiuBookPageData

@synthesize pageName = _pageName;
@synthesize pageBytes = _pageBytes;

- (DuxiuBookPageData *)initWithPageName:(NSString *)pageName pageByte:(NSMutableData *)pageBytes
{
    if (self = [super init])
    {
        _pageName = pageName;
        _pageBytes = pageBytes;
    }
    return self;
}

@end
