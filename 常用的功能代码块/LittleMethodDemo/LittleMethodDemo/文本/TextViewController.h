//
//  TextViewController.h
//  LittleMethodDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextViewController : UIViewController

/** 打印系统中所有字体的类型名字 */
- (void)getFontNames;

/** 创建自定义的触摸手势来实现对键盘的隐藏 */
- (void)tapBackgroundHideKeyboard;

@end

NS_ASSUME_NONNULL_END
