//
//  MotionViewController.m
//  UIKitGrammarDemo
//
//  Created by 谢佳培 on 2020/10/30.
//

#import "MotionViewController.h"

@interface MotionViewController ()

@end

@implementation MotionViewController

// 手指按下时响应
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"手指按下时响应");
}

// 手指移动时响应
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    NSLog(@"手指移动时响应");
}

// 手指抬起时响应
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    NSLog(@"手指抬起时响应");
}

// 触摸取消(意外中断, 如:电话, Home键退出等)
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"取消触摸响应(意外中断, 如:电话, Home键退出等)");
}

#pragma mark - 运动事件监听

// 开始加速
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [super motionBegan:motion withEvent:event];
    NSLog(@"开始加速");
}

// 结束加速
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [super motionEnded:motion withEvent:event];
    NSLog(@"结束加速");
}

// 加速取消（意外中断, 如:电话, Home键退出等）
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [super motionCancelled:motion withEvent:event];
    NSLog(@"加速取消");
}


@end
