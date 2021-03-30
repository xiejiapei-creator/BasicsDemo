//
//  RefreshView.m
//  AnimationDemo
//
//  Created by 谢佳培 on 2021/3/30.
//

#import "RefreshView.h"

const CGFloat PullLoadingViewSize = 30.0;

@interface RefreshView ()

@property (nonatomic, strong) CALayer *wheelLayer;
@property (nonatomic, strong) NSArray *windLayers;
@property (nonatomic, strong) NSArray *windOffsets;

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation RefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self drawRefreshView];
    }
    return self;
}

- (void)drawRefreshView
{
    // 下拉80点转动一周
    _distanceForTurnOneCycle = 80;
    // 类似计时器，但每一帧都会调用
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayDidRefresh)];
    // 放到NSRunLoopCommonModes，防止下拉切换mode导致计时器失效
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    

    CGFloat halfWidth = self.bounds.size.width / 2;// 视图一半
    CGPoint center = CGPointMake(halfWidth, halfWidth);// 轮胎中心点
    
    // 创建轮胎视图
    _wheelLayer = [CALayer layer];
    _wheelLayer.frame = self.bounds;
    [self.layer addSublayer:_wheelLayer];
    
//拆分为两部分，轮胎使用描边，扇叶使用填充
    //轮胎描边
    UIBezierPath *wheelMaskPath = [UIBezierPath bezierPathWithArcCenter:center radius:halfWidth startAngle:0 endAngle:M_PI*2 clockwise:YES];// 路径为外圆
    CAShapeLayer *wheelMask = [CAShapeLayer layer];// 外层轮胎图层
    wheelMask.frame = self.bounds;
    wheelMask.path = wheelMaskPath.CGPath;// 外层轮胎图层上的路径
    
    CGFloat tyreRadius = 23/2 - 1.5;// 内层轮胎半径
    UIColor *tyreColor = [UIColor redColor];// 内层轮胎颜色为红色
    CAShapeLayer *tyreLayer = [CAShapeLayer layer];// 内层轮胎图层
    UIBezierPath *tyrePath =[UIBezierPath bezierPathWithArcCenter:center radius:tyreRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];// 路径为内圆
    [tyrePath closePath];// 关闭路径
    tyreLayer.path = tyrePath.CGPath;// 内层轮胎图层上的路径
    tyreLayer.strokeColor = tyreColor.CGColor;// 描边颜色
    tyreLayer.lineWidth = 3;// 描边宽度
    tyreLayer.fillColor = [UIColor clearColor].CGColor;// 填充颜色
    tyreLayer.frame = self.bounds;
    tyreLayer.mask = wheelMask;// 遮罩
    [_wheelLayer addSublayer:tyreLayer];// 将形状图层添加到轮胎图层上
    
    // 扇叶
    CGFloat innerRadius = 7/2;
    CGFloat outerRadius = 15/2;
    CGFloat angleDelta = M_PI * 2 / 5;// 转动角度
    CGFloat arcAngle = angleDelta * 2 / 3;// 圆弧角度
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];// 遮罩路径
    for (int i=0; i<5; i++)
    {
        CGFloat startAngle = angleDelta * i;// 开始角度
        CGFloat endAngle = startAngle + arcAngle;// 开始角度 + 弧度 = 结束角度
        CGPoint innerArcStart = [self calcPointWithAngle:endAngle radius:innerRadius center:center];// 计算开始点
        CGPoint outerArcStart = [self calcPointWithAngle:startAngle radius:outerRadius center:center];// 计算结束点
        
        // 绘制路径
        UIBezierPath *path = [UIBezierPath bezierPath];
        // 外部弧
        [path addArcWithCenter:center radius:outerRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
        // 连线
        [path addLineToPoint:innerArcStart];
        // 内部弧
        [path addArcWithCenter:center radius:innerRadius startAngle:endAngle endAngle:startAngle clockwise:NO];
        // 连线
        [path addLineToPoint:outerArcStart];
        // 闭合
        [path closePath];
        [maskPath appendPath:path];
    }
    
    // 内部环
    CGFloat dotRadius = 3.0 / 2;// 点半径
    UIBezierPath *dotPath = [UIBezierPath bezierPathWithArcCenter:center radius:dotRadius startAngle:0 endAngle:M_PI*2 clockwise:YES];// 画圆
    [dotPath closePath];// 闭合
    [maskPath appendPath:dotPath];// 添加到遮罩路径
    
    // 遮罩图层
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    UIColor *fanBladeColor = [UIColor redColor];// 风扇颜色
    CALayer *fanBladeLayer = [CALayer layer];// 风扇图层
    fanBladeLayer.backgroundColor = fanBladeColor.CGColor;// 背景颜色为红色
    fanBladeLayer.frame = self.bounds;
    fanBladeLayer.mask = maskLayer;// 遮罩图层
    // 也可将fanBladeLayer添加到tyreLayer中
    [tyreLayer addSublayer:fanBladeLayer];
    
// 风
    UIColor *windColor = [UIColor redColor];// 风的颜色为红色
    NSMutableArray *windLayers = [NSMutableArray array];
    for (int i=0; i<3; i++)
    {
        // 创建风图层
        CAShapeLayer *layer = [CAShapeLayer layer];// 图层
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(6, 0)];// 绘制线条
        layer.path = path.CGPath;// 图层的线条
        layer.strokeColor = windColor.CGColor;// 描边颜色为风的颜色
        layer.lineWidth = 1.0;// 描边宽度
        layer.position = [self resetWindLayerPositionWithIndex:i];// 根据index计算风视图的开始位置
        layer.opacity = 0.0;// 刚开始透明
        [self.layer addSublayer:layer];// 添加风图层
        [windLayers addObject:layer];// 放到风图层的集合中
    }
    _windLayers = windLayers;
    _windOffsets = @[@18, @23, @16];// 根据index计算风视图的X轴上的坐标偏移量
}

// 轮胎动画
- (void)wheelAnimation
{
    // 设置Z轴上的旋转动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(M_PI*2);
    animation.toValue = @(0);// 转动一圈
    animation.removedOnCompletion = NO;// 完成后不移除
    animation.repeatCount = HUGE_VALF;// 重复
    animation.duration = 1.0;// 1秒
    [_wheelLayer addAnimation:animation forKey:@"loading"];// 作为加载动画
}

// 吹风动画
- (void)windAnimation
{
    // 为3个风图层分别添加动画
    for (int i=0; i<3; i++)
    {
        [self addAnimationToWindLayerForIndex:i];
    }
}

// 在风视图上添加动画
- (void)addAnimationToWindLayerForIndex:(NSInteger)index
{
    CGFloat duration = 1.5;// 1.5秒

// 移动动画
    // 根据index计算风视图的开始位置
    CGPoint startPosition = [self resetWindLayerPositionWithIndex:index];
    // 根据index计算风视图的X轴上的坐标偏移量
    CGFloat offsetX = [_windOffsets[index] floatValue];
    // 风视图的结束位置
    CGPoint endPosition = CGPointMake(startPosition.x+offsetX, startPosition.y);
    
    // 设置关键位置：开始->结束->开始
    NSArray *positions = @[[NSValue valueWithCGPoint:startPosition],
                           [NSValue valueWithCGPoint:endPosition],
                           [NSValue valueWithCGPoint:endPosition],
                           [NSValue valueWithCGPoint:startPosition]];
    // 设置时间点
    NSArray *positionKeyTimes = @[@0, @(1.0/duration), @(1.3/duration), @1.0];
    // 设置动画效果
    NSArray *positionFunctions = @[[CAMediaTimingFunction functionWithName:
                                   kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:
                                   kCAMediaTimingFunctionLinear],
                                  [CAMediaTimingFunction functionWithName:
                                   kCAMediaTimingFunctionLinear]];
    
// 透明度动画
    // 设置关键点的透明度
    NSArray *opacities = @[@0.0, @1.0, @1.0, @0.0, @0.0];
    // 设置时间点
    NSArray *opacityKeyTimes = @[@0, @(0.3/duration), @(1.0/duration), @(1.3/duration), @1.0];
    // 设置动画效果
    NSArray *opacityFunctions = @[[CAMediaTimingFunction functionWithName:
                                kCAMediaTimingFunctionEaseOut],
                               [CAMediaTimingFunction functionWithName:
                                kCAMediaTimingFunctionLinear],
                               [CAMediaTimingFunction functionWithName:
                                kCAMediaTimingFunctionEaseOut],
                               [CAMediaTimingFunction functionWithName:
                                kCAMediaTimingFunctionLinear]];
    
    // 根据index获取创建好的风图层，并将其本地化
    CALayer *windLayer = _windLayers[index];
    
    // 创建透明度动画
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = opacities;
    opacityAnimation.keyTimes = opacityKeyTimes;
    opacityAnimation.timingFunctions = opacityFunctions;
    
    // 创建位置动画
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = positions;
    positionAnimation.keyTimes = positionKeyTimes;
    positionAnimation.timingFunctions = positionFunctions;
    
    // 创建组合动画
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[opacityAnimation, positionAnimation];
    groupAnimation.duration = duration;
    groupAnimation.repeatCount = HUGE_VALF;// 重复无限次
    
    // 将组合动画作为风动画添加到风图层上
    [windLayer addAnimation:groupAnimation forKey:@"wind"];
}

// 根据index计算风视图的开始位置
- (CGPoint)resetWindLayerPositionWithIndex:(NSInteger)index
{
    CGFloat positionX = self.bounds.size.width/2 + 23/2 - 3;
    CGFloat positionYDelta = 5;
    CGFloat positionYStart = self.bounds.size.width/2 - positionYDelta;
    return CGPointMake(positionX, positionYStart + positionYDelta*index);
}

- (CGPoint)calcPointWithAngle:(CGFloat)angle radius:(CGFloat)radius center:(CGPoint)center
{
    // 正弦和余弦函数计算坐标点
    CGFloat postionX = center.x + radius * cos(angle);
    CGFloat postionY = center.y + radius * sin(angle);
    return CGPointMake(postionX, postionY);
}

// 滚动视图存在则实现下拉加载联动效果
- (void)displayDidRefresh
{
    if (_scrollView)
    {
        // 总下拉距离
        CGFloat distance = _scrollView.contentOffset.y;
        // 2PI *（总下拉距离 / 80）= 转动几圈
        CGFloat angle = - (M_PI * 2 * distance / _distanceForTurnOneCycle);
        // 仿射变换实现旋转效果
        CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
        // 在轮胎图层上添加旋转动画
        [_wheelLayer setAffineTransform:transform];
    }
}

// 下拉加载，开始风和轮胎动画
- (void)loading
{
    // 停止关联
    _displayLink.paused = YES;
    [self wheelAnimation];
    [self windAnimation];
}

// 当取消或者加载完成的时机会调用这个方法
- (void)loadingFinished
{
    // 启动关联
    _displayLink.paused = NO;
    // 移除加载动画
    [_wheelLayer removeAnimationForKey:@"loading"];
    for (CALayer *layer in _windLayers)
    {
        [layer removeAllAnimations];
    }
}

- (void)dealloc
{
    [_displayLink invalidate];
}

@end
