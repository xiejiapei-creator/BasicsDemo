//
//  UIButton+Custom.h
//  CategoryUIDemo
//
//  Created by 谢佳培 on 2020/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Custom)

@property (nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

/** 设置按钮响应区域 */
- (void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets;

@end

NS_ASSUME_NONNULL_END
