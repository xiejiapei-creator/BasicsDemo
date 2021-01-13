//
//  AppDelegate.m
//  CategoryUIDemo
//
//  Created by 谢佳培 on 2020/11/26.
//

#import "AppDelegate.h"
#import "testNSStringViewController.h"
#import "testUIScreenViewController.h"
#import "testUIViewViewController.h"
#import "testUIColorViewController.h"
#import "testUIImageViewController.h"
#import "testUILabelViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    testUILabelViewController *rootVC = [[testUILabelViewController alloc] init];
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainNC;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
