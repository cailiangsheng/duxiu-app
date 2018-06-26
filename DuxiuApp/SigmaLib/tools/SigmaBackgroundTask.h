//
//  SigmaBackgroundTask.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SigmaBackgroundTask : NSObject

+ (void)enterBackgroundWhenNeedTask:(BOOL(^)(void))needTask
                             onWait:(void(^)(void))onWait
                            onSleep:(void(^)(void))onSleep
                           onWakeUp:(void(^)(void))onWakeUp;

+ (void)enterForeground;

+ (void)terminate;

@end
