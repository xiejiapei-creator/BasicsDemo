//
//  UINavigationController+Custom.m
//  CategoryUIDemo
//
//  Created by 谢佳培 on 2020/11/26.
//

#import "UINavigationController+Custom.h"

@implementation UINavigationController (Custom)

// 弹出到指定的页面类
- (UIViewController *)popToViewController:(Class)classType
{
    for (UIViewController *controller in self.viewControllers)
    {
        if ([controller isKindOfClass:classType])
        {
            [self popToViewController:controller animated:YES];
            return controller;
        }
    }
    return nil;
}

// 移除指定的页面类，并保证当前页面不会被剔除掉
- (void)removeViewController:(Class)classType currentVC:(UIViewController *)currentVC
{
    NSMutableArray *arrayVC = [self.viewControllers mutableCopy];
    BOOL isRemove = NO;
    // 逆序遍历
    for (UIViewController *viewController in [arrayVC reverseObjectEnumerator])
    {
        if ([viewController isKindOfClass:classType] && currentVC && viewController!=currentVC)
        {
            [arrayVC removeObject:viewController];
            isRemove = YES;
        }
    }
    if (isRemove)
    {
        [self setViewControllers:arrayVC animated:YES];
    }
}

// 得到需要移除的View
- (NSMutableArray *)getNeedRemoveViewControllers:(NSArray *)array
{
    NSMutableArray *arrayVC = [self.viewControllers mutableCopy];
    for (UIViewController *viewController in [arrayVC reverseObjectEnumerator])
    {
        [array enumerateObjectsUsingBlock:^(Class  _Nonnull classType, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([viewController isKindOfClass:classType])
            {
                [arrayVC removeObject:viewController];
            }
        }];
    }
    return arrayVC;
}

@end
