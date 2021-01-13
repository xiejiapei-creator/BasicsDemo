//
//  UIColor+Custom.h
//  CategoryDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Custom)

/// 使用16进制进行颜色设置
+ (UIColor *)colorWithHex:(NSString *)string;

/// 随机颜色
+ (UIColor *)randomColor;


@end

NS_ASSUME_NONNULL_END
