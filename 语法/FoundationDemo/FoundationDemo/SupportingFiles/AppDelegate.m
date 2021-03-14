//
//  AppDelegate.m
//  FoundationDemo
//
//  Created by 谢佳培 on 2020/10/21.
//

#import "AppDelegate.h"
#import "BaseUseViewController.h"
#import "CommonUseViewController.h"
#import "TimerViewController.h"
#import "DateViewController.h"
#import "CollectionViewController.h"
#import "strViewController.h"
#import "HeaderViewController.h"
#import "CollectionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    TimerViewController *rootVC = [[TimerViewController alloc] init];
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainNC;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
