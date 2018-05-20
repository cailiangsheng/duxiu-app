//
//  SigmaCookieUtil.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-10.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SigmaCookieUtil.h"
#import "SigmaFileUtil.h"

@interface SigmaCookieUtil ()

@end

static NSMutableDictionary *_cookieMap = nil;

@implementation SigmaCookieUtil

NSMutableDictionary *getCookieMap()
{
    if (_cookieMap == nil)
    {
        _cookieMap = [[NSMutableDictionary alloc] init];
    }
    return _cookieMap;
}

NSMutableDictionary *getCookieObject(NSString *objName)
{
    if (objName)
    {
        return [getCookieMap() objectForKey:objName];
    }
    return nil;
}

NSString *getCookieName(NSMutableDictionary *object)
{
    if (object)
    {
        for (NSString *key in [getCookieMap() keyEnumerator])
        {
            if ([getCookieMap() valueForKey:key] == object)
            {
                return key;
            }
        }
    }
    return nil;
}

NSString *getCookieFilePath(NSString *objName)
{
    NSString *fileName = [NSString stringWithFormat:@"/Settings/%@.cookie", objName];
    NSString *filePath = [[SigmaFileUtil libraryDirectory] stringByAppendingPathComponent:fileName];
    return filePath;
}

NSMutableDictionary *createSharedObject(NSString *objName)
{
    NSString *filePath = getCookieFilePath(objName);
    NSMutableDictionary *so = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    if (so)
    {
        NSLog(@"Read Cookie: %@", filePath);
    }
    else
    {
        NSLog(@"Failed to read: %@", filePath);
        so = [[NSMutableDictionary alloc] init];
    }
    return so;
}

BOOL flushSharedObject(NSMutableDictionary *object)
{
    NSString *objName = getCookieName(object);
    if (objName)
    {
        NSString *filePath = getCookieFilePath(objName);
        [SigmaFileUtil createFile:filePath];
        
        if ([object writeToFile:filePath atomically:YES])
        {
            NSLog(@"Write Cookie: %@", filePath);
            return true;
        }
        else {
            NSLog(@"Failed to write: %@", filePath);
        }
    }
    return false;
}

+ (NSMutableDictionary *)openCookieWithName:(NSString *)objName
{
    if (objName)
    {
        NSMutableDictionary *so = createSharedObject(objName);
        if (getCookieObject(objName) == nil)
        {
            [getCookieMap() setValue:so forKey:objName];
        }
        return so;
    }
    return nil;
}

+ (BOOL)clearCookie:(NSMutableDictionary *)object
{
    if (object)
    {
        if (getCookieName(object) != nil)
        {
            [object removeAllObjects];
            return true;
        }
    }
    return false;
}

+ (BOOL)closeCookie:(NSMutableDictionary *)object
{
    return flushSharedObject(object);
}

@end
