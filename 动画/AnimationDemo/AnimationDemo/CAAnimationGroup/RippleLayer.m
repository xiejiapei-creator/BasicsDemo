//
//  RippleLayer.m
//  AnimationDemo
//
//  Created by 谢佳培 on 2021/3/30.
//

//#import <FLAnimatedImage/FLAnimatedImage.h>
#import "RippleLayer.h"
#import <UIKit/UIKit.h>

@interface RippleLayer ()<CAAnimationDelegate>// 动画委托

// 计时器
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RippleLayer

- (CAShapeLayer *)rippleLayer
{
    // 路径
    CGSize size = self.bounds.size;
    CGFloat raduis = size.width/2;// 半径
    CGPoint center = CGPointMake(size.width/2, size.height/2);// 圆心
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:raduis startAngle:0 endAngle:M_PI*2 clockwise:YES];// 圆
    [path closePath];// 闭合
    
    UIColor *strokeColor = [UIColor colorWithRed:189.0/255 green:141.0/255 blue:4.0/255 alpha:0.45];// 描边颜色
    UIColor *fillColor = [UIColor colorWithRed:189.0/255 green:141.0/255 blue:4.0/255 alpha:0.08];// 填充颜色
    
    // 图层
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = 0.5;
    layer.strokeColor = strokeColor.CGColor;
    layer.fillColor = fillColor.CGColor;
    
    // 勿改变设置顺序
    layer.anchorPoint = CGPointMake(0.5, 0.5);// 铆点 0～1 这里指视图中心
    layer.frame = self.bounds;
    layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.0);// 缩放
    layer.opacity = 0.0;// 透明
    
    return layer;
}

- (void)fireRippleAnimation
{
    // 添加轮胎图层
    CAShapeLayer *layer = [self rippleLayer];
    [self addSublayer:layer];
    
// scalePath
    UIBezierPath *scalePath = [UIBezierPath bezierPath];
    [scalePath moveToPoint:CGPointMake(1.5, 0)];
    [scalePath addQuadCurveToPoint:CGPointMake(1.8, 1.0) controlPoint:CGPointMake(1.2, 0.2)];
    [scalePath addQuadCurveToPoint:CGPointMake(3.0, 3.0) controlPoint:CGPointMake(3.0, 2.5)];
    
// opacityPath
    UIBezierPath *opacityPath = [UIBezierPath bezierPath];
    [opacityPath moveToPoint:CGPointZero];
    [opacityPath addLineToPoint:CGPointMake(0.8, 0.2)];
    [opacityPath addLineToPoint:CGPointMake(0.0, 2.5)];
    [opacityPath addLineToPoint:CGPointMake(0.0, 3.0)];
    
    CFTimeInterval duration = 3.0;
    
// ScaleAnimation
    CAKeyframeAnimation *xScaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    xScaleAnimation.calculationMode = kCAAnimationPaced;
    xScaleAnimation.path = scalePath.CGPath;
    xScaleAnimation.duration = duration;
    
    CAKeyframeAnimation *yScaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    yScaleAnimation.calculationMode = kCAAnimationPaced;
    yScaleAnimation.path = scalePath.CGPath;
    yScaleAnimation.duration = duration;
    
// OpacityAnimation
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.calculationMode = kCAAnimationPaced;
    opacityAnimation.path = opacityPath.CGPath;
    opacityAnimation.duration = duration;
    
// GroupAnimation
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[xScaleAnimation,yScaleAnimation,opacityAnimation];
    groupAnimation.duration = duration;
    groupAnimation.delegate = self;
    groupAnimation.removedOnCompletion = NO;
    
    // 给图层添加动画
    [layer addAnimation:groupAnimation forKey:@"groupAnimation"];
}

- (void)startAnimation
{
    // 已经在计时则直接返回
    if (_timer)
    {
        return;
    }
    
    // 代理机制防止计时器的循环引用
    //FLWeakProxy *target = [FLWeakProxy weakProxyForObject:self];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fireRippleAnimation) userInfo:nil repeats:YES];
}

- (void)stopAnimation
{
    [_timer invalidate];
    _timer = nil;
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    // 删除最低部的layer
    CALayer *layer = [self.sublayers firstObject];
    [layer removeFromSuperlayer];
}

@end
