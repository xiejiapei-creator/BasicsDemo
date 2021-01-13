//
//  UINavigationController+Custom.h
//  CategoryUIDemo
//
//  Created by 谢佳培 on 2020/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Custom)

/** 弹出到指定的页面类 */
- (UIViewController *)popToViewController:(Class)classType;

/** 移除指定的页面类，并保证当前页面不会被剔除掉 */
- (void)removeViewController:(Class)classType currentVC:(UIViewController *)currentVC;

/** 得到需要移除的View */
- (NSMutableArray *)getNeedRemoveViewControllers:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
