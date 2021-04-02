//
//  BallsLoadingView.m
//  AnimationDemo
//
//  Created by 谢佳培 on 2021/3/30.
//

#import "BallsLoadingView.h"

const CGFloat BallsLoadingLayerSize = 100.0;// 加载图层的大小

@interface BallsLoadingView ()

@property (nonatomic, strong) CALayer *loadingLayer;// 加载图层

@end

@implementation BallsLoadingView

- (void)drawInnerLoadingLayer
{
    CGSize size = self.bounds.size;
    CGFloat radius = size.width/2;// 半径
    CGFloat dotRadius = 7.5 * (size.width/BallsLoadingLayerSize);// 球的半径
    CGFloat postionRadius = radius - dotRadius;// 距离
    CGFloat angleDelta = M_PI / 4;// 角度变化量
    
    // 1.创建加载图层
    _loadingLayer = [CALayer layer];
    _loadingLayer.frame = self.bounds;
    [self.layer addSublayer:_loadingLayer];
    
    
    // 2.绘制8个球
    UIColor *ballColor = [UIColor blueColor];// 球的颜色
    for (int i=7; i>=0; i--)
    {
        // 计算每个球的圆心
        CGFloat postionX = radius + postionRadius * cos(angleDelta*i);
        CGFloat postionY = radius + postionRadius * sin(angleDelta*i);
        
        // 绘制每个球的路径
        UIBezierPath *dotPath = [UIBezierPath bezierPath];
        [dotPath addArcWithCenter:CGPointZero radius:dotRadius startAngle:0 endAngle:M_PI*2 clockwise:YES];
        [dotPath closePath];
        
        // 创建形状图层
        CAShapeLayer *dotLayer = [CAShapeLayer layer];
        dotLayer.position = CGPointMake(postionX, postionY);// 球的放置位置
        dotLayer.anchorPoint = CGPointZero;// 球的锚点
        dotLayer.path = dotPath.CGPath;// 绘制路径
        dotLayer.fillColor = ballColor.CGColor;// 填充颜色
        
        // 将形状图层添加到加载图层上
        [_loadingLayer addSublayer:dotLayer];
    }
}

// 小球依次缩放和透明
- (void)configureAnimation
{
    // 获取加载图层中的每个球图层
    NSArray<CALayer *> *sublayers = _loadingLayer.sublayers;
    // 球的数量
    NSUInteger count = sublayers.count;
    // 依次延迟0.12秒展示
    CGFloat delayDelta = 0.12;
    
    // 依次为每个球添加动画
    for (int i=0; i<count; i++)
    {
        // 获取每个球的图层
        CALayer *subLayer = sublayers[i];
        
        NSArray *scales = @[@1.0, @0.4, @1.0];// 缩放 1->0.4->1
        NSArray *opacities = @[@1.0, @0.3, @1.0];// 透明度 1->0.3->1
        NSArray *keyTimes = @[@0, @0.5, @1.0];// 关键时刻 0->0.5->1
        CGFloat duration = 2.0;// 时长
        
        // xScale: X轴上的缩放动画
        CAKeyframeAnimation *xScaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
        xScaleAnimation.values = scales;
        xScaleAnimation.keyTimes = keyTimes;
        xScaleAnimation.duration = duration;
        
        // yScale: Y轴上的缩放动画
        CAKeyframeAnimation *yScaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
        yScaleAnimation.values = scales;
        yScaleAnimation.keyTimes = keyTimes;
        yScaleAnimation.duration = duration;
        
        // opacity: 透明度动画
        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = opacities;
        opacityAnimation.keyTimes = keyTimes;
        opacityAnimation.duration = duration;
        
        // 组合动画
        CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
        groupAnimation.animations = @[xScaleAnimation, yScaleAnimation, opacityAnimation];
        groupAnimation.duration = duration;
        groupAnimation.removedOnCompletion = NO;// 完成后不移除动画
        groupAnimation.repeatCount = HUGE_VALF;// 无限次重复
        groupAnimation.beginTime = delayDelta * i;// 依次延迟0.12秒展示
        
        // 将组合动画添加到球图层上
        [subLayer addAnimation:groupAnimation forKey:@"groupAnimation"];
    }
}

- (void)startAnimation
{
    [self configureAnimation];
}

- (void)stopAnimation
{
    // 获取加载图层中的每个球图层
    NSArray<CALayer *> *sublayers = _loadingLayer.sublayers;
    NSUInteger count = sublayers.count;
    
    for (int i=0; i<count; i++)
    {
        // 获取每个球的图层
        CALayer *subLayer = sublayers[i];
        // 移除球图层上的所有动画
        [subLayer removeAllAnimations];
    }
}

@end



