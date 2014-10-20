//
//  AppDelegate.h
//  iReserve
//
//  Created by apple on 14-9-23.
//  Copyright (c) 2014年 MichaelDu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPDeepSleepPreventer.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MMPDeepSleepPreventer *sleepPreventer;
@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTaskID;
@property (nonatomic, assign) BOOL isBackgroud;
@end
