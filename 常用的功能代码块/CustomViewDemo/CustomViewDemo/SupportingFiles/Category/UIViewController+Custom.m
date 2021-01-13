//
//  UIViewController+Custom.m
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/9.
//

#import "UIViewController+Custom.h"
#import <objc/runtime.h>

@implementation UINavigationController (Custom)

// 当我们调用setNeedsStatusBarAppearanceUpdate的时候
// 系统会调用rootViewController的preferredStatusBarStyle方法
// 根本不会调用子控制器的preferredStatusBarStyle方法
// 只要UIViewController重写的childViewControllerForStatusBarStyle返回值不是nil
// 调用childViewControllerForStatusBarStyle返回的UIViewController的preferredStatusBarStyle来控制StatuBar的颜色
- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

// 这两个鬼东西不会被调用？？？
- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.topViewController;
}

@end

@implementation UIViewController (Custom)

- (BOOL)statusBarAppearanceCheck
{
    NSDictionary *appInfo = [NSBundle mainBundle].infoDictionary;
    if ([appInfo.allKeys containsObject:@"UIViewControllerBasedStatusBarAppearance"])
    {
        return [appInfo[@"UIViewControllerBasedStatusBarAppearance"] integerValue];
    }
    return YES;
}

#pragma mark - 是否隐藏状态栏

- (BOOL)statusBarHidden
{
    id value = objc_getAssociatedObject(self, _cmd);
    return [value boolValue];
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden
{
    objc_setAssociatedObject(self, @selector(statusBarHidden), @(statusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if ([self statusBarAppearanceCheck])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] setStatusBarHidden:statusBarHidden];
#pragma clang diagnostic pop
    }
}

- (BOOL)prefersStatusBarHidden
{
    return self.statusBarHidden;
}

#pragma mark - 状态栏的风格样式

- (UIStatusBarStyle)statusBarStyle
{
    id value = objc_getAssociatedObject(self, _cmd);
    return [value integerValue];
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    objc_setAssociatedObject(self, @selector(statusBarStyle), @(statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if ([self statusBarAppearanceCheck])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle];
#pragma clang diagnostic pop
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusBarStyle;
}

#pragma mark - 重置状态栏为默认

- (void)statusBarRestoreDefaults
{
    if ([self statusBarAppearanceCheck])
    {
        self.statusBarStyle = UIStatusBarStyleDefault;
        self.statusBarHidden = NO;
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
#pragma clang diagnostic pop
    }
}

@end
