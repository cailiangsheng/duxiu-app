//
//  SigmaCookieUtil.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-10.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SigmaCookieUtil : NSObject

+ (NSMutableDictionary*)openCookieWithName:(NSString *)objName;
+ (BOOL)clearCookie:(NSMutableDictionary *)object;
+ (BOOL)closeCookie:(NSMutableDictionary *)object;

@end
