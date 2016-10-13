//
//  AppDelegate.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/9.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "DB.h"
#import "CategoaryModel.h"
#import "TotalDownloader.h"
#import "XGPush.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UMSocialData setAppKey:@"55ffbd59e0f55afb5b000415"];
    
    NSArray *array = [DB allDownloading];
    TotalDownloader *total = [TotalDownloader shareTotalDownloader];
    for (CategoaryModel *model in array) {
        [total addDownloadingWithURL:model.playUrl];
    }
    
    //推送
    [XGPush startApp:2200152737 appKey:@"I99PKT89CG3U"];
    
    //判断系统版本号
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0) {
        //通知提示的类型
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        //注册一个通知
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    } else {
        //8.0以前注册APNS的方法
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
    
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (_isRotation) {
        //如果为YES，则只支持横屏
        return UIInterfaceOrientationMaskLandscape;
    }
    //只支持竖屏
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - 推送
//接收到通知.返回给token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [XGPush registerDevice:deviceToken];
}

///接收到通知后,点击进去执行的方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //点击进去之后,把角标改为0
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
