//
//  DuxiuBookPageDefine.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuBookPageZoom.h"
#import "DuxiuBookPageType.h"

@interface DuxiuBookPageDefine : NSObject

+ (NSString *)pageTypeAll;
+ (NSString *)pageTypeOthers;
+ (NSString *)pageTypeContent;
+ (NSArray *)pageTypes;

+ (NSString *)pageZoomOrigin;
+ (NSString *)pageZoomLarge;
+ (NSString *)pageZoomMedium;
+ (NSString *)pageZoomSmall;
+ (NSArray *)pageZooms;

+ (BOOL)isOriginPageZoom:(int)pageZoomEnum;
+ (BOOL)isContentPageType:(NSString *)type;
+ (BOOL)isFuzzyPageType:(NSString *)type;
+ (NSArray *)getRealPageTypes:(NSString *)type;

+ (DuxiuBookPageZoom *)getPageZoom:(NSString *)zoom;
+ (DuxiuBookPageType *)getPageType:(NSString *)type;
+ (int)maxPageNo:(NSString *)type;
+ (DuxiuBookPageType *)getPageTypeEx:(NSString *)pageName;
+ (NSString *)getPageOriginSymbol:(NSString *)pageName;
+ (NSString *)getPageOrderSymbol:(NSString *)pageName;
+ (NSNumber *)getPageNo:(NSString *)pageName;
+ (NSString *)getPageNameByType:(NSString *)type pageNo:(NSNumber *)pageNo origin:(BOOL)isOrigin;
+ (NSString *)getPageOriginNameByType:(NSString *)type pageNo:(NSNumber *)pageNo;
+ (NSString *)getPageOrderNameByType:(NSString *)type pageNo:(NSNumber *)pageNo;

@end
