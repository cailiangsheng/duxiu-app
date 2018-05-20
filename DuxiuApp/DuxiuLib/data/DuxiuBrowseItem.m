//
//  DuxiuBrowseItem.m
//  DuxiuDown
//
//  Created by 良胜 蔡 on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuBrowseItem.h"

#import "SigmaBrowserUtil.h"

@implementation DuxiuBrowseItem

@synthesize name = _name;
@synthesize url = _url;

+ (DuxiuBrowseItem *)itemWithName:(NSString *)name andURL:(NSString *)url
{
    DuxiuBrowseItem *item = [[DuxiuBrowseItem alloc] init];
    if (item)
    {
        item.name = name;
        item.url = url;
    }
    return item;
}

- (NSString *)httpUrl
{
    return [SigmaBrowserUtil getHttpUrl:_url];
}

@end
