//
//  UIScreen+Custom.h
//  CategoryDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScreen (Custom)

#pragma mark - 获取属性值

/// 尺寸
+ (CGSize)size;

/// 宽度
+ (CGFloat)width;

/// 高度
+ (CGFloat)height;

/// 缩放率
+ (CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
