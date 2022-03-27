//
//  AppDelegate.m
//  BreakpointContinuationDemo
//
//  Created by 谢佳培 on 2020/8/5.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "AppDelegate.h"
#import "DownLoadViewController.h"
#import "URLSessionDownloadViewController.h"

@interface AppDelegate ()

@property (nonatomic, copy) NSString *identifier;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DownLoadViewController *rootVC = [[DownLoadViewController alloc] init];
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainNC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // 实现如下代码，才能使程序处于后台被杀死时调用到applicationWillTerminate:方法
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(){}];
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler
{
    self.identifier = identifier;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"任务已经下载好了: %@",self.identifier);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"程序被杀死，applicationWillTerminate");
}

@end
