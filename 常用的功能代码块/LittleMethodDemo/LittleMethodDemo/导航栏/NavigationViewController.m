//
//  NavigationViewController.m
//  LittleMethodDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import "NavigationViewController.h"
#import "TextViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

// 获取当前页面的控制器
- (UIViewController *)currentViewController
{
    UIViewController* currentViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    BOOL runLoopFind = YES;
    while (runLoopFind)
    {
        if (currentViewController.presentedViewController)
        {
            currentViewController = currentViewController.presentedViewController;
            
        }
        else if ([currentViewController isKindOfClass:[UINavigationController class]])
        {
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
            
        }
        else if ([currentViewController isKindOfClass:[UITabBarController class]])
        {
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
            
        }
        else
        {
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            
            if (childViewControllerCount > 0)
            {
                currentViewController = currentViewController.childViewControllers.lastObject;
                return currentViewController;
            }
            else
            {
                return currentViewController;
            }
        }
    }
    
    return currentViewController;
}

// 在导航栏栈中寻找到指定的页面返回
- (void)backToNeedViewController
{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    for (UIViewController *viewController in [self.navigationController viewControllers])
    {
        [viewControllers addObject:viewController];
    
        if ([viewController isKindOfClass:[TextViewController class]])
        {
            break;
        }
    }
    
    [self.navigationController setViewControllers:viewControllers   animated:YES];
}

// 设置导航栏全透明
/*
- (void)viewWillAppear:(BOOL)animated
{
    // 设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    // 去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
 */

- (void)viewWillDisappear:(BOOL)animated
{
    // 如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:nil];
    
    // 如果仅仅需要禁止此单个页面返回，还需要重新开放侧滑权限
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

// 禁止侧滑返回上个页面功能
- (void)disableSideslipReturn
{
    // 1.首先把顶部左侧返回按钮隐藏掉
    self.navigationItem.hidesBackButton = YES;
    
    // 2.再禁止页面左侧滑动返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

// 更改导航栏的返回按钮的标题与颜色
- (void)changeNavigationBarTitleAndColor
{
    // 返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // 修改返回按钮的颜色
    self.navigationController.navigationBar.tintColor = [UIColor redColor];

    // 设置导航条的色调
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    // 导航栏默认是半透明状态
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    
    // 导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.navigationController.navigationBar.translucent = NO;
}
@end
