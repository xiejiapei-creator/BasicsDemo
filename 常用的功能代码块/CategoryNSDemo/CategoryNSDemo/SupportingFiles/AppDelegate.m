//
//  AppDelegate.m
//  CategoryNSDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import "AppDelegate.h"
#import "testNSDateViewController.h"
#import "testNSObjectViewController.h"
#import "testNSNumberViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    testNSNumberViewController *rootVC = [[testNSNumberViewController alloc] init];
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainNC;
    [self.window makeKeyAndVisible];

    return YES;
}


@end
