//
//  AppDelegate.m
//  KVO_KVC_Demo
//
//  Created by 谢佳培 on 2020/9/24.
//

#import "AppDelegate.h"
#import "KVOUseViewController.h"
#import "KVCUseViewController.h"
#import "KVOPrincipleViewController.h"
#import "CustomKVOViewController.h"
#import "CustomAdvancedKVOViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CustomAdvancedKVOViewController *rootVC = [[CustomAdvancedKVOViewController alloc] init];
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainNC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
