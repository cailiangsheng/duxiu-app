//
//  DuxiuBookPageDefine.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuBookPageDefine.h"

#import "SigmaStringUtil.h"

@interface DuxiuBookPageDefine ()

@end

static NSArray *_pageZooms = nil;
static NSArray *_pageTypes = nil;

@implementation DuxiuBookPageDefine

+ (NSString *)pageTypeAll
{
    return @"全部";
}

+ (NSString *)pageTypeOthers
{
    return @"其他";
}

+ (NSString *)pageTypeContent
{
    return @"正文";
}

static int PageOriginNameLength = 6;

+ (NSString *)pageZoomOrigin
{
    return @"原图";
}

+ (NSString *)pageZoomLarge
{
    return @"大图";
}

+ (NSString *)pageZoomMedium
{
    return @"中图";
}

+ (NSString *)pageZoomSmall
{
    return @"小图";
}

+ (NSArray *)pageZooms
{
    if (_pageZooms == nil)
    {
        _pageZooms = [[NSArray alloc] initWithObjects:
                      [[DuxiuBookPageZoom alloc] initWithZoomName:@"原图" zoomEnum:3],
                      [[DuxiuBookPageZoom alloc] initWithZoomName:@"大图" zoomEnum:2],
                      [[DuxiuBookPageZoom alloc] initWithZoomName:@"中图" zoomEnum:1],
                      [[DuxiuBookPageZoom alloc] initWithZoomName:@"小图" zoomEnum:0],
                      nil];
    }
    return _pageZooms;
}

+ (NSArray *)pageTypes
{
    if (_pageTypes == nil)
    {
        _pageTypes = [[NSArray alloc] initWithObjects:
                      [[DuxiuBookPageType alloc] initWithTypeName:@"全部" originSymbol:nil orderSymbol:nil maxNo:nil], 
                      [[DuxiuBookPageType alloc] initWithTypeName:@"其他" originSymbol:nil orderSymbol:nil maxNo:nil],
                      [[DuxiuBookPageType alloc] initWithTypeName:@"正文" originSymbol:@"0" orderSymbol:@"F0" maxNo:nil],
                      [[DuxiuBookPageType alloc] initWithTypeName:@"封面" originSymbol:@"cov" orderSymbol:@"A000" maxNo:[NSNumber numberWithInt:2]],
                      [[DuxiuBookPageType alloc] initWithTypeName:@"书名" originSymbol:@"bok" orderSymbol:@"B000" maxNo:[NSNumber numberWithInt:1]],
                      [[DuxiuBookPageType alloc] initWithTypeName:@"版权" originSymbol:@"leg" orderSymbol:@"C000" maxNo:[NSNumber numberWithInt:3]],
                      [[DuxiuBookPageType alloc] initWithTypeName:@"前言" originSymbol:@"fow" orderSymbol:@"D000" maxNo:nil],
                      [[DuxiuBookPageType alloc] initWithTypeName:@"目录" originSymbol:@"!" orderSymbol:@"E0" maxNo:nil],
                      [[DuxiuBookPageType alloc] initWithTypeName:@"附录" originSymbol:@"att" orderSymbol:@"G000" maxNo:nil],
                      [[DuxiuBookPageType alloc] initWithTypeName:@"封底" originSymbol:@"bac" orderSymbol:@"H000" maxNo:nil],
                      [[DuxiuBookPageType alloc] initWithTypeName:@"插页" originSymbol:@"ins" orderSymbol:@"I000" maxNo:nil],
                      nil];
    }
    return _pageTypes;
}

+ (BOOL)isOriginPageZoom:(int)pageZoomEnum
{
    return pageZoomEnum == 3;
}

+ (BOOL)isContentPageType:(NSString *)type
{
    return [type isEqualToString:[DuxiuBookPageDefine pageTypeContent]];
}

+ (BOOL)isFuzzyPageType:(NSString *)type
{
    return [type isEqualToString:[DuxiuBookPageDefine pageTypeAll]] || 
            [type isEqualToString:[DuxiuBookPageDefine pageTypeOthers]];
}

+ (NSArray *)getRealPageTypes:(NSString *)type
{
    if ([type isEqualToString:[DuxiuBookPageDefine pageTypeAll]])
    {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 9)];
        return [[DuxiuBookPageDefine pageTypes] objectsAtIndexes:indexSet];
    }
    else if ([type isEqualToString:[DuxiuBookPageDefine pageTypeOthers]])
    {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 8)];
        return [[DuxiuBookPageDefine pageTypes] objectsAtIndexes:indexSet];
    }
    else
    {
        DuxiuBookPageType *pageType = [DuxiuBookPageDefine getPageType:type];
        if (pageType)
        {
            return [NSArray arrayWithObject:pageType];
        }
    }
    return nil;
}

+ (DuxiuBookPageZoom *)getPageZoom:(NSString *)zoom
{
    for (DuxiuBookPageZoom *pageZoom in [DuxiuBookPageDefine pageZooms]) {
        if ([pageZoom.zoomName isEqualToString:zoom])
            return pageZoom;
    }
    return nil;
}

+ (DuxiuBookPageType *)getPageType:(NSString *)type
{
    for (DuxiuBookPageType *pageType in [DuxiuBookPageDefine pageTypes]) {
        if ([pageType.typeName isEqualToString:type])
            return pageType;
    }
    return nil;
}

+ (int)maxPageNo:(NSString *)type
{
    DuxiuBookPageType *pageType = [DuxiuBookPageDefine getPageType:type];
    if (pageType)
    {
        NSNumber *maxNo = pageType.maxNo;
        if (maxNo == nil)
        {
            NSString *originSymbol = pageType.orderSymbol;
            return [repeatChar(@"9", PageOriginNameLength - originSymbol.length) intValue];
        }
        else {
            return maxNo.intValue;
        }
    }
    return 0;
}

+ (DuxiuBookPageType *)getPageTypeEx:(NSString *)pageName
{
    if (pageName)
    {
        for (DuxiuBookPageType *pageType in [DuxiuBookPageDefine pageTypes]) {
            if ([SigmaStringUtil checkString:pageName hasPrefix:pageType.originSymbol] || 
                [SigmaStringUtil checkString:pageName hasPrefix:pageType.orderSymbol])
                return pageType;
        }
    }
    return nil;
}

+ (NSString *)getPageOriginSymbol:(NSString *)pageName
{
    DuxiuBookPageType *pageType = [DuxiuBookPageDefine getPageTypeEx:pageName];
    return pageType ? pageType.originSymbol : nil;
}

+ (NSString *)getPageOrderSymbol:(NSString *)pageName
{
    DuxiuBookPageType *pageType = [DuxiuBookPageDefine getPageTypeEx:pageName];
    return pageType ? pageType.orderSymbol : nil;
}

NSString *replaceOnce(NSString *text, NSString *pattern, NSString *str)
{
    NSRange range = [text rangeOfString:pattern];
    if (range.location != NSNotFound)
    {
        return [text stringByReplacingCharactersInRange:range withString:str];
    }
    return text;
}

+ (NSNumber *)getPageNo:(NSString *)pageName
{
    DuxiuBookPageType *pageType = [DuxiuBookPageDefine getPageTypeEx:pageName];
    if (pageType)
    {
        int no = 0;
        if ([SigmaStringUtil checkString:pageName hasPrefix:pageType.originSymbol])
            no = replaceOnce(pageName, pageType.originSymbol, @"").intValue;
        else
            no = replaceOnce(pageName, pageType.orderSymbol, @"").intValue;
        return [NSNumber numberWithInt:no];
    }
    return nil;
}

NSMutableString *repeatChar(NSString *c, int len)
{
    NSMutableString *str = [[NSMutableString alloc] init];
    if (len > 0)
    {
        for (int i = 0; i < len; i++)
        {
            [str appendString:c];
        }
    }
    return str;
}

+ (NSString *)getPageNameByType:(NSString *)type pageNo:(NSNumber *)pageNo origin:(BOOL)isOrigin
{
    DuxiuBookPageType *pageType = [DuxiuBookPageDefine getPageType:type];
    if (pageType && pageNo)
    {
        NSString *originSymbol = pageType.originSymbol;
        NSString *no = pageNo.stringValue;
        NSString *zeros = repeatChar(@"0", PageOriginNameLength - originSymbol.length - no.length);
        return [NSString stringWithFormat:@"%@%@%@", (isOrigin ? originSymbol : pageType.orderSymbol), zeros, no];
    }
    return nil;
}

+ (NSString *)getPageOriginNameByType:(NSString *)type pageNo:(NSNumber *)pageNo
{
    return [DuxiuBookPageDefine getPageNameByType:type pageNo:pageNo origin:true];
}

+ (NSString *)getPageOrderNameByType:(NSString *)type pageNo:(NSNumber *)pageNo
{
    return [DuxiuBookPageDefine getPageNameByType:type pageNo:pageNo origin:false];
}

@end
