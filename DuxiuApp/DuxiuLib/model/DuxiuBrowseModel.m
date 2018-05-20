//
//  DuxiuBrowseModel.m
//  DuxiuDown
//
//  Created by 良胜 蔡 on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuBrowseModel.h"

#import "SigmaBrowserUtil.h"

#import "SigmaCookieUtil.h"

@interface DuxiuBrowseModel ()

@property (strong) NSMutableDictionary *cookie;

@end

@implementation DuxiuBrowseModel

@synthesize bookmarks = _bookmarks;
@synthesize location = _location;

@synthesize cookie = _cookie;

- (DuxiuBrowseModel *)init
{
    if (self = [super init])
    {
        NSMutableArray *list1 = [[NSMutableArray alloc] init];
        [list1 addObject:[DuxiuBrowseItem itemWithName:@"读秀首页" andURL:@"www.duxiu.com"]];
        [list1 addObject:[DuxiuBrowseItem itemWithName:@"指针首页" andURL:@"www.zhizhen.com"]];
        [list1 addObject:[DuxiuBrowseItem itemWithName:@"超星首页" andURL:@"www.sslibrary.com"]];
        [list1 addObject:[DuxiuBrowseItem itemWithName:@"读秀镜像" andURL:@"http://220.168.54.196/duxiu/lg.asp?Uname=cddcq&Upwd=cddcq123"]];
        
        NSMutableArray *list2 = [[NSMutableArray alloc] init];
        [list2 addObject:[DuxiuBrowseItem itemWithName:@"QQ邮箱" andURL:@"mail.qq.com"]];
        [list2 addObject:[DuxiuBrowseItem itemWithName:@"163邮箱" andURL:@"mail.163.com"]];
        
        NSMutableArray *list3 = [[NSMutableArray alloc] init];
        [list3 addObject:[DuxiuBrowseItem itemWithName:@"百度搜索" andURL:@"www.baidu.com"]];
        [list3 addObject:[DuxiuBrowseItem itemWithName:@"粘贴打开" andURL:URL_CLIPBOARD]];
        
        _bookmarks = [[NSMutableArray alloc] initWithObjects:list1, list2, list3, nil];
        
        _cookie = [SigmaCookieUtil openCookieWithName:@"browseModel"];
        NSString *cookieLocation = [_cookie valueForKey:@"location"];
        
        _location = cookieLocation ? cookieLocation : [(DuxiuBrowseItem *)[list1 objectAtIndex:0] httpUrl];
    }
    return self;
}

- (void)dealloc
{
    [self save];
}

- (void)save
{
    [_cookie setValue:_location forKey:@"location"];
    
    [SigmaCookieUtil closeCookie:_cookie];
}

- (void)setLocation:(NSString *)location
{
    if (![_location isEqualToString:location])
    {
        _location = location;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_BROWSE_LOCATION_CHANGE object:self];
    }
}

@end
