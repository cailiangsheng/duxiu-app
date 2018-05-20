//
//  SigmaURLLoader.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#define EVENT_URLLOADER_ERROR @"eventURLLoaderError"
#define EVENT_URLLOADER_COMPLETE @"eventURLLoaderComplete"

@interface SigmaURLLoader : NSObject

@property (strong) NSMutableData *data;

- (BOOL)load:(NSString *)url;
- (void)close;

@end
