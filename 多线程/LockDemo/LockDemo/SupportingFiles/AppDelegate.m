//
//  AppDelegate.m
//  LockDemo
//
//  Created by 谢佳培 on 2021/4/6.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    RootViewController *rootVC = [[RootViewController alloc] init];
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainNC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
