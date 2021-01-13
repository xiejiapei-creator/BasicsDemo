//
//  UIViewController+Custom.h
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Custom)

@end

@interface UIViewController (Custom)

/** 是否隐藏状态栏 */
@property (nonatomic, assign) BOOL statusBarHidden;

/** 状态栏的风格样式 */
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

/** 重置状态栏为默认 */
- (void)statusBarRestoreDefaults;

@end

NS_ASSUME_NONNULL_END
