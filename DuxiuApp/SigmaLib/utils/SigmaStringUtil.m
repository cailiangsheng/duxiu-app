//
//  SigmaStringUtil.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SigmaStringUtil.h"

@implementation SigmaStringUtil

+ (BOOL)checkString:(NSString *)str hasPrefix:(NSString *)prefix
{
    return str && prefix && [str hasPrefix:prefix];
}

@end
