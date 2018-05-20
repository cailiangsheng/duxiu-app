//
//  SigmaFileUtil.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

@interface SigmaFileUtil : NSObject

+ (BOOL)isOverwritable:(NSString *)filePath;
+ (BOOL)createDirectory:(NSString *)dirPath;
+ (BOOL)createFile:(NSString *)filePath;
+ (BOOL)writeBytes:(NSData *)bytes atFilePath:(NSString *)filePath;

+ (BOOL)exploreFile:(NSString *)filePath;

+ (NSString *)homeDirectory;
+ (NSString *)documentsDirectory;
+ (NSString *)libraryDirectory;
+ (NSString *)cachesDirectory;

@end
