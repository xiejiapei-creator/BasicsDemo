//
//  AppDelegate.m
//  APP-B
//
//  Created by 谢佳培 on 2020/9/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "WasteMaterialsViewController.h"
#import "WriterViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    ViewController *rootVC = [[ViewController alloc] init];
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainNC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    NSString *sourceId = options[@"UIApplicationOpenURLOptionsSourceApplicationKey"];
    NSLog(@"openURL:url=%@;sourceId=%@;options=%@",url,sourceId,options);

    // 1.获取导航栏控制器
    UINavigationController *rootNavigationVC = (UINavigationController *)self.window.rootViewController;

    // 2.每次跳转前必须是在根控制器(细节)
    [rootNavigationVC popToRootViewControllerAnimated:NO];

    // 3.根据字符串关键字来跳转到不同页面
    if ([url.absoluteString containsString:@"WriterViewController"]) //跳转到应用App-B的WriterViewController页面
    {
        // 进行跳转
        WriterViewController *vc = [[WriterViewController alloc] init];
        // 保存完整的App-A的URL给主控制器
        vc.urlString = url.absoluteString;
        [rootNavigationVC pushViewController:vc animated:YES];
    }
    else if ([url.absoluteString containsString:@"WasteMaterialsViewController"])// 跳转到应用App-B的WasteMaterialsViewController页面
    {
        // 进行跳转
        WasteMaterialsViewController *vc = [[WasteMaterialsViewController alloc] init];
        // 保存完整的App-A的URL给主控制器
        vc.urlString = url.absoluteString;
        [rootNavigationVC pushViewController:vc animated:YES];
    }

    return YES;
}

@end


