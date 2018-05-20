//
//  DuxiuBookPageCounter.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuBookPageCounter.h"

@interface DuxiuBookPageCounter ()

@property (strong) NSArray *ranges;

@end

@implementation DuxiuBookPageCounter

@synthesize ranges = _ranges;

- (DuxiuBookPageCounter *)init
{
    if (self = [super init])
    {
        _ranges = [[NSArray alloc] initWithObjects:
                   [[DuxiuBookPageRange alloc] initWithPageTypeName:@"正文"], 
                   [[DuxiuBookPageRange alloc] initWithPageTypeName:@"封面"],
                   [[DuxiuBookPageRange alloc] initWithPageTypeName:@"书名"],
                   [[DuxiuBookPageRange alloc] initWithPageTypeName:@"版权"],
                   [[DuxiuBookPageRange alloc] initWithPageTypeName:@"前言"],
                   [[DuxiuBookPageRange alloc] initWithPageTypeName:@"目录"],
                   [[DuxiuBookPageRange alloc] initWithPageTypeName:@"附录"],
                   [[DuxiuBookPageRange alloc] initWithPageTypeName:@"封底"],
                   [[DuxiuBookPageRange alloc] initWithPageTypeName:@"插页"],
                   nil];
    }
    return self;
}

- (int)numPages
{
    int num = 0;
    for (DuxiuBookPageRange *range in _ranges) {
        num += range.total;
    }
    return num;
}

- (int)numMissings
{
    int num = 0;
    for (DuxiuBookPageRange *range in _ranges) {
        num += range.numMissings;
    }
    return num;
}

- (int)numOriginRenamed
{
    int num = 0;
    for (DuxiuBookPageRange *range in _ranges) {
        num += range.numOriginRenamed;
    }
    return num;
}

- (int)numOrderRenamed
{
    int num = 0;
    for (DuxiuBookPageRange *range in _ranges) {
        num += range.numOrderRenamed;
    }
    return num;
}

- (NSString *)description
{
    NSString *desc = [NSMutableString stringWithFormat:@"总计:  %d", self.numPages];
    desc = [desc stringByAppendingFormat:@"\n缺页:  %d", self.numMissings];
    for (DuxiuBookPageRange *range in _ranges) {
        desc = [desc stringByAppendingFormat:@"\n%@:  %@", range.pageTypeName, range];
    }
    return desc;
}

- (void)beginCount
{
    for (DuxiuBookPageRange *range in _ranges) {
        [range reset];
    }
}

- (void)endCount
{
    for (DuxiuBookPageRange *range in _ranges) {
        [range sort];
    }
}

- (void)countPageByName:(NSString *)pageName
{
    for (DuxiuBookPageRange *range in _ranges) {
        [range addPageByName:pageName];
    }
}

- (BOOL)countAtDirPath:(NSString *)dirPath
{
    [self beginCount];
    
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir] && isDir)
    {
        NSArray *subNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
        for (NSString *subName in subNames) {
            NSString *subPath = [dirPath stringByAppendingPathComponent:subName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:subPath isDirectory:&isDir] && !isDir)
            {
                NSString *pageName = [subName stringByDeletingPathExtension];
                [self countPageByName:pageName];
            }
        }
        
        [self endCount];
        return true;
    }
    
    [self endCount];
    return false;
}

@end
