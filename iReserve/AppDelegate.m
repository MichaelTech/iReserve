//
//  AppDelegate.m
//  iReserve
//
//  Created by apple on 14-9-23.
//  Copyright (c) 2014年 MichaelDu. All rights reserved.
//

#import "AppDelegate.h"
#import "ReserveController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //处理background task，才能在后台发声
    self.bgTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTaskID];
        self.bgTaskID = UIBackgroundTaskInvalid;
    }];
        
    ReserveController *vc = [[ReserveController alloc] initWithNibName:@"ReserveController" bundle:nil];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    self.isBackgroud = YES;
    [self.sleepPreventer startPreventSleep];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    self.isBackgroud = NO;
    [self.sleepPreventer stopPreventSleep];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
