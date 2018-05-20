//
//  DuxiuBookPageIterator.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuBookPageIterator.h"

#import "DuxiuBookPageDefine.h"

@interface DuxiuBookPageIterator ()

@property (weak) DuxiuTaskModel *taskModel;

@property (strong) NSArray *targetPageTypes;
@property (nonatomic) int curPageTypeIndex;
@property (nonatomic) int curPageNumber;

@end

@implementation DuxiuBookPageIterator

@synthesize taskModel = _taskModel;

@synthesize targetPageTypes = _targetPageTypes;
@synthesize curPageTypeIndex = _curPageTypeIndex;
@synthesize curPageNumber = _curPageNumber;

- (DuxiuBookPageIterator *)initWithTaskModel:(DuxiuTaskModel *)taskModel
{
    if (self = [super init])
    {
        _taskModel = taskModel;
    }
    return self;
}

- (void)dispose
{
    _taskModel = nil;
}

- (DuxiuBookPageType *)curPageType
{
    if (_targetPageTypes && 
        _curPageTypeIndex >= 0 && 
        _curPageTypeIndex < [_targetPageTypes count])
    {
        return [_targetPageTypes objectAtIndex:_curPageTypeIndex];
    }
    return nil;
}

- (NSNumber *)curFromPage
{
    if (_taskModel && self.curPageType)
    {
        return [_taskModel getFromPage:self.curPageType.typeName];
    }
    return nil;
}

- (NSNumber *)curToPage
{
    if (_taskModel && self.curPageType)
    {
        return [_taskModel getToPage:self.curPageType.typeName];
    }
    return nil;
}

- (int)curPageNumber
{
    return _curPageNumber;
}

- (BOOL)isValid
{
    return [self isValidPageType] && [self isValidPageNumber];
}

- (BOOL)isValidPageType
{
    return (_targetPageTypes && _targetPageTypes.count > 0 && 
            _curPageTypeIndex >= 0 && _curPageTypeIndex < _targetPageTypes.count);
}

- (BOOL)isValidPageNumber
{
    return _curPageNumber >= [self curFromPage].intValue && _curPageNumber <= [self curToPage].intValue;
}

- (void)setPageType:(NSString *)pageType
{
    _targetPageTypes = [DuxiuBookPageDefine getRealPageTypes:pageType];
    _curPageTypeIndex = 0;
    _curPageNumber = [self curFromPage].intValue;
}

- (BOOL)nextPageNumber
{
    _curPageNumber++;
    
    if (self.isValid)
    {
        return true;
    }
    else
    {
        return [self nextPageType];
    }
}

- (BOOL)nextPageType
{
    _curPageTypeIndex++;
    _curPageNumber = [self curFromPage].intValue;
    
    return self.isValid;
}

@end
