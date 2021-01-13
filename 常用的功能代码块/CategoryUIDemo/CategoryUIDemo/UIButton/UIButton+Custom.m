//
//  UIButton+Custom.m
//  CategoryUIDemo
//
//  Created by 谢佳培 on 2020/11/26.
//

#import "UIButton+Custom.h"
#import <objc/runtime.h>

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";

@implementation UIButton (Custom)

#pragma mark - 设置按钮响应区域
 
// 设置响应区域
- (void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets
{
    // 将hitTestEdgeInsets封装为NSValue
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    // 将value与button通过key关联起来
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 获取响应区域
- (UIEdgeInsets)hitTestEdgeInsets
{
    // 通过key获取到button关联的value（hitTestEdgeInsets）
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value)
    {
        // 从value中取出hitTestEdgeInsets的值
        UIEdgeInsets edgeInsets;
        [value getValue:&edgeInsets];
        return edgeInsets;
    }
    else
    {
        return UIEdgeInsetsZero;
    }
}

// 点击区域
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden)
    {
        return [super pointInside:point withEvent:event];
    }
    
    // 响应区域存在，button存在且可以点击
    CGRect relativeFrame = self.bounds;
    // 偷偷摸摸地修改了按钮的frame
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    // 点击的是修改后的frame
    return CGRectContainsPoint(hitFrame, point);
}



@end
