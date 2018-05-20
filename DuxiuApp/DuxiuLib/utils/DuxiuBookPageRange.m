//
//  DuxiuBookPageRange.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuBookPageRange.h"

#import "DuxiuBookPageDefine.h"

#import "SigmaStringUtil.h"

@interface DuxiuBookPageRange ()

@property (copy) NSString *pageTypeName;
@property (strong) NSMutableArray *range;

@property (nonatomic) int numOriginRenamed;
@property (nonatomic) int numOrderRenamed;

@property (strong) NSMutableArray *missings;

@end

@implementation DuxiuBookPageRange

@synthesize pageTypeName = _pageTypeName;
@synthesize range = _range;

@synthesize numOriginRenamed = _numOriginRenamed;
@synthesize numOrderRenamed = _numOrderRenamed;

@synthesize missings = _missings;

- (DuxiuBookPageRange *)initWithPageTypeName:(NSString *)pageTypeName
{
    if (self = [super init])
    {
        _pageTypeName = pageTypeName;
        _range = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)reset
{
    [_range removeAllObjects];
    _numOriginRenamed = 0;
    _numOrderRenamed = 0;
}

- (void)sort
{
    [_range sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        NSNumber *n1 = (NSNumber *)obj1;
        NSNumber *n2 = (NSNumber *)obj2;
        NSComparisonResult result = [n1 compare:n2];
        return result == NSOrderedDescending;
    }];
}

NSUInteger indexOfIntValue(NSArray *arr, int intValue)
{
    if (arr)
    {
        for (int i = 0, n = arr.count; i < n; i++)
        {
            NSNumber *num = [arr objectAtIndex:i];
            if (num.intValue == intValue)
            {
                return i;
            }
        }
    }
    return NSNotFound;
}

- (BOOL)addPageByName:(NSString *)pageName
{
    DuxiuBookPageType *pageType = [DuxiuBookPageDefine getPageTypeEx:pageName];
    if (pageType && [_pageTypeName isEqualToString:pageType.typeName])
    {
        NSNumber *pageNo = [DuxiuBookPageDefine getPageNo:pageName];
        if (indexOfIntValue(_range, pageNo.intValue) == NSNotFound)
        {
            if ([SigmaStringUtil checkString:pageName hasPrefix:pageType.originSymbol])
            {
                _numOriginRenamed++;
            }
            else if ([SigmaStringUtil checkString:pageName hasPrefix:pageType.orderSymbol])
            {
                _numOrderRenamed++;
            }
            
            [_range addObject:pageNo];
            return true;
        }
    }
    return false;
}

- (NSString *)pageTypeName
{
    return _pageTypeName;
}

- (int)total
{
    return _range.count;
}

- (int)minNo
{
    return _range.count > 0 ? ((NSNumber *)[_range objectAtIndex:0]).intValue : 0;
}

- (int)maxNo
{
    return _range.count > 0 ? ((NSNumber *)[_range lastObject]).intValue : 0;
}

- (BOOL)isSequential
{
    return self.numMissings == 0;
}

- (int)numMissings
{
    return self.total == 0 ? 0 : self.maxNo - self.minNo + 1 - self.total;
}

- (int)numOriginRenamed
{
    return _numOriginRenamed;
}

- (int)numOrderRenamed
{
    return _numOrderRenamed;
}

- (NSArray *)missings
{
    if (_missings == nil)
        _missings = [[NSMutableArray alloc] init];
    else
        [_missings removeAllObjects];
    
    if (!self.isSequential)
    {
        for (int i = self.minNo, max = self.maxNo; i <= max; i++)
        {
            if (indexOfIntValue(_range, i) == NSNotFound)
            {
                [_missings addObject:[NSNumber numberWithInt:i]];
            }
        }
    }
    return _missings;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%d  [%d,%d]  %@", self.total, self.minNo, self.maxNo, (self.isSequential ? @"√" : @"×")];
}

@end
