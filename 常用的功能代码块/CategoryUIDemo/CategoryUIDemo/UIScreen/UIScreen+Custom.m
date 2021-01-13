//
//  UIScreen+Custom.m
//  CategoryDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import "UIScreen+Custom.h"

@implementation UIScreen (Custom)

#pragma mark - 获取属性值

// 尺寸
+ (CGSize)size
{
    return [[UIScreen mainScreen] bounds].size;
}

// 宽度
+ (CGFloat)width
{
    return [[UIScreen mainScreen] bounds].size.width;
}

// 高度
+ (CGFloat)height
{
    return [[UIScreen mainScreen] bounds].size.height;
}

// 缩放率
+ (CGFloat)scale
{
    return [UIScreen mainScreen].scale;
}

@end
