//
//  AppDelegate.m
//  UIKitGrammarDemo
//
//  Created by 谢佳培 on 2020/10/21.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TableViewController.h"
#import "MotionViewController.h"
#import "GestureRecognizerViewController.h"
#import "AlertViewController.h"
#import "PickerViewController.h"
#import "ScrollViewController.h"
#import "ControlViewController.h"
#import "InputViewViewController.h"
#import "TableViewController.h"
#import "CollectionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    PickerViewController *rootVC = [[PickerViewController alloc] init];
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainNC;
    [self.window makeKeyAndVisible];

    return YES;
}
@end
