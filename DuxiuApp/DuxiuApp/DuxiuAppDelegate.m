//
//  DuxiuAppDelegate.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuAppDelegate.h"

#import "DuxiuModel.h"
#import "DuxiuController.h"

#import "SigmaBackgroundTask.h"

@implementation DuxiuAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onControllerIdle) name:EVENT_CONTROLLER_IDLE object:[DuxiuController instance]];
    return YES;
}

- (void)onControllerIdle
{
    [SigmaBackgroundTask terminate];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[DuxiuController instance] onDeactivate];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [SigmaBackgroundTask enterBackgroundWhenNeedTask:^BOOL(){return [DuxiuModel instance].isBuzy;} 
                                              onWait:^{[[DuxiuController instance] onDeactivate];} 
                                             onSleep:^{[[DuxiuController instance] onSleep];} 
                                            onWakeUp:^{[[DuxiuController instance] onWakeUp];}];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [SigmaBackgroundTask enterForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[DuxiuController instance] onActivate];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [SigmaBackgroundTask terminate];
}

@end
