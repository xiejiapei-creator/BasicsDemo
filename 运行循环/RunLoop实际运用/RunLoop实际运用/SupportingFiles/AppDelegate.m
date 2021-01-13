//
//  AppDelegate.m
//  RunLoop实际运用
//
//  Created by 谢佳培 on 2020/8/20.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "AppDelegate.h"
#import "ResidentThreadBySourceViewController.h"
#import "ResidentThreadByPortViewController.h"
#import "ResidentThreadByTimerViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ResidentThreadByPortViewController *rootVC = [[ResidentThreadByPortViewController alloc] init];
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainNC;
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
