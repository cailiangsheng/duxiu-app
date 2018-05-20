//
//  DuxiuBookPageType.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuBookPageType.h"

@implementation DuxiuBookPageType

@synthesize typeName =  _typeName;
@synthesize originSymbol = _originSymbol;
@synthesize orderSymbol = _orderSymbol;
@synthesize maxNo = _maxNo;

- (DuxiuBookPageType *)initWithTypeName:(NSString *)typeName originSymbol:(NSString *)originSymbol orderSymbol:(NSString *)orderSymbol maxNo:(NSNumber *)maxNo
{
    self = [super init];
    if (self)
    {
        _typeName = typeName;
        _originSymbol = originSymbol;
        _orderSymbol = orderSymbol;
        _maxNo = maxNo;
    }
    return self;
}

@end
