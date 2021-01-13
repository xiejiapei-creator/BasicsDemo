//
//  UIImage+Custom.h
//  FunctionCodeBlockDemo
//
//  Created by 谢佳培 on 2020/9/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Custom)

/** 直接设置圆角会很卡，用绘图来做，放到分类中使用 */
- (UIImage *)imageWithCornerRadius:(CGFloat)radius ofSize:(CGSize)size;

/** 通过颜色来生成图片 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
