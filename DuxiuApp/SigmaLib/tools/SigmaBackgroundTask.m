//
//  SigmaBackgroundTask.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SigmaBackgroundTask.h"

@implementation SigmaBackgroundTask

static UIBackgroundTaskIdentifier _taskId = 0;
static BOOL (^_needTask)() = nil;
static void (^_onWait)() = nil;
static void (^_onSleep)() = nil;
static void (^_onWakeUp)() = nil;

UIApplication *getApplication()
{
    return [UIApplication sharedApplication];
}

void endBackgroundTask()
{
    if (_taskId != UIBackgroundTaskInvalid)
    {
        NSLog(@"End background taskId: %d", _taskId);
        [getApplication() endBackgroundTask:_taskId];
        _taskId = UIBackgroundTaskInvalid;
    }
}

void resetBackgroundTask()
{
    _needTask = nil;
    _onWait = nil;
    _onSleep = nil;
    _onWakeUp = nil;
    
    [getApplication() clearKeepAliveTimeout];
    endBackgroundTask();
    NSLog(@"Background task is over!");
}

void stopBackgroundTask()
{
    if (_onSleep)
    {
        _onSleep();
    }
    
    resetBackgroundTask();
    NSLog(@"Application Terminated!");
}

void cancelBackgroundTask()
{
    if (_onWakeUp)
    {
        _onWakeUp();
    }
    
    resetBackgroundTask();
    NSLog(@"Application WakeUp!");
}

void waitBackgroundTask()
{
    if (_onWait)
    {
        _onWait();
    }
    NSLog(@"Background task is to be continued...");
    
    endBackgroundTask();
    NSLog(@"Applicatioin Waiting...");
}

BOOL beginBackgroundTask()
{
    UIApplication *application = [UIApplication sharedApplication];
    
    if (_needTask && _needTask())
    {
        endBackgroundTask();
        _taskId = [application beginBackgroundTaskWithExpirationHandler:^
                  {
                      NSLog(@"Background task timeout!");
                      
                      if (_needTask && _needTask())
                      {
                          waitBackgroundTask();
                      }
                      else
                      {
                          stopBackgroundTask();
                      }
                  }];
        
        if (_taskId != UIBackgroundTaskInvalid)
        {
            NSLog(@"Begin background taskId: %d", _taskId);
            if (_onWakeUp)
            {
                _onWakeUp();
            }
            return true;
        }
    }
    
    stopBackgroundTask();
    return false;
}

void startBackgroundTask(BOOL(^needTask)(), void(^onWait)(), void(^onSleep)(), void(^onWakeUp)())
{
    _needTask = needTask;
    _onWait = onWait;
    _onSleep = onSleep;
    _onWakeUp = onWakeUp;
    
    // Only VoIP apps can set KeepAliveTimeout
    // add the following to app-Info.plist:
    
    //<key>UIBackgroundModes</key>
    //<array>
    //  <string>voip</string>
    //</array>
    
    if ([getApplication() setKeepAliveTimeout:600 handler:^
         {
             NSLog(@"VoIP-keepAlive Timeout!");
             beginBackgroundTask();
         }])
    {
        NSLog(@"Setup VoIP-keepAliveTimeout handler!");
    }
    
    NSLog(@"Try to begin a first background task!");
    _taskId = UIBackgroundTaskInvalid;
    beginBackgroundTask();
}

//----------------------------------------------------------
+ (void)enterBackgroundWhenNeedTask:(BOOL(^)())needTask 
                             onWait:(void(^)())onWait 
                            onSleep:(void(^)())onSleep 
                           onWakeUp:(void(^)())onWakeUp
{
    startBackgroundTask(needTask, onWait, onSleep, onWakeUp);
}

+ (void)enterForeground
{
    cancelBackgroundTask();
}

+ (void)terminate
{
    stopBackgroundTask();
}

@end
