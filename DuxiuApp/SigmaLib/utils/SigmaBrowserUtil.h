//
//  SigmaBrowserUtil.h
//  DuxiuDown
//
//  Created by 良胜 蔡 on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define URL_NULL @"about:blank"
#define URL_CLIPBOARD @"about:clipboard"

@interface SigmaBrowserUtil : NSObject

+ (NSString *)getHttpUrl:(NSString *)url;

+ (BOOL)compareURL:(NSString *)url1 withURL:(NSString *)url2;

+ (BOOL)navigateToURL:(NSString *)url;

@end
