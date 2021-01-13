//
//  UIImage+Custom.m
//  FunctionCodeBlockDemo
//
//  Created by 谢佳培 on 2020/9/25.
//

#import "UIImage+Custom.h"

@implementation UIImage (Custom)

// 直接设置圆角会很卡，用绘图来做，放到分类中使用
- (UIImage *)imageWithCornerRadius:(CGFloat)radius ofSize:(CGSize)size
{
    // 边界问题
    if(radius < 0)
    {
        radius = 0;
    }
    else if (radius > MIN(size.height, size.width))
    {
        // 如果radius大于最小边，取最小边的一半
        radius = MIN(size.height, size.width)/2;
    }
    
    // 当前image的可见绘制区域
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    // 创建基于位图的上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);//scale:范围

    /*
     // 在当前位图的上下文添加圆角绘制路径
     CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
     // 当前绘制路径和原绘制路径相交得到最终裁减绘制路径
     CGContextClip(UIGraphicsGetCurrentContext());
     */
    // 等效于上面的2句代码
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    
    // 绘制
    [self drawInRect:rect];
    
    // 取得裁减后的image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭当前位图上下文
    UIGraphicsEndImageContext();
    
    return image;
}

// 通过颜色来生成图片
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
