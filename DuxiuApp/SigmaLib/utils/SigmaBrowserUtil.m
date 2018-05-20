//
//  SigmaBrowserUtil.m
//  DuxiuDown
//
//  Created by 良胜 蔡 on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SigmaBrowserUtil.h"

@implementation SigmaBrowserUtil

+ (NSString *)getHttpUrl:(NSString *)url
{
    if ([[url lowercaseString] isEqualToString:URL_CLIPBOARD])
    {
        if ([[UIPasteboard generalPasteboard] containsPasteboardTypes:UIPasteboardTypeListString])
        {
            url = [[UIPasteboard generalPasteboard] string];
        }
        else
        {
            url = nil;
        }
    }
    
    if (url == nil || [url length] == 0)
    {
        return URL_NULL;
    }
    else
    {
        NSString *httpUrl = url;
        if (![httpUrl isEqualToString:URL_NULL] && 
            ![httpUrl hasPrefix:@"http://"] && 
            ![httpUrl hasPrefix:@"https://"] && 
            ![httpUrl hasPrefix:@"file:"] && 
            ![httpUrl hasPrefix:@"data:"] && 
            ![httpUrl hasPrefix:@"javascript:"])
        {
            httpUrl = [NSString stringWithFormat:@"http://%@", httpUrl];
        }
        return httpUrl;
    }
}

+ (BOOL)compareURL:(NSString *)url1 withURL:(NSString *)url2
{
    if (url1 == url2)
    {
        return true;
    }
    else if (url1 && url2)
    {
        if (url1.length < url2.length)
        {
            NSString *temp = url1;
            url1 = url2;
            url2 = temp;
        }
        
        NSRange p = [url1 rangeOfString:url2];
        if (p.location != NSNotFound)
        {
            NSString *suffix = [url1 substringFromIndex:(p.location + url2.length)];
            return [suffix hasPrefix:@"#"];
        }
    }
    return false;
}

+ (BOOL)navigateToURL:(NSString *)url
{
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
