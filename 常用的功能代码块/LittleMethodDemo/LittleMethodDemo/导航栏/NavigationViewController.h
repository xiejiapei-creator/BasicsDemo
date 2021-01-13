//
//  NavigationViewController.h
//  LittleMethodDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NavigationViewController : UIViewController

/** 在导航栏栈中寻找到指定的页面返回 */
- (void)backToNeedViewController;

/** 禁止侧滑返回上个页面功能 */
- (void)disableSideslipReturn;

/** 更改导航栏的返回按钮的标题与颜色 */
- (void)changeNavigationBarTitleAndColor;

@end

NS_ASSUME_NONNULL_END
