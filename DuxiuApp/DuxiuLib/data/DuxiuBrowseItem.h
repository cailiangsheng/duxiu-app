//
//  DuxiuBrowseItem.h
//  DuxiuDown
//
//  Created by 良胜 蔡 on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

@interface DuxiuBrowseItem : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;

+ (DuxiuBrowseItem *)itemWithName:(NSString *)name andURL:(NSString *)url;

- (NSString *)httpUrl;

@end
