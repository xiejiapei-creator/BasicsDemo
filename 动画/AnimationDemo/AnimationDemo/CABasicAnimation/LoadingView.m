//
//  LoadingView.m
//  AnimationDemo
//
//  Created by 谢佳培 on 2021/3/30.
//

#import "LoadingView.h"

const CGFloat LoadingViewSize = 200.0;// 加载视图的大小
const CGFloat LoadingLayerWidth = 80.0;// 加载图层的宽度

@interface LoadingView ()<CAAnimationDelegate>

// 是否正在动画
@property (nonatomic, assign, getter=isAnimating) BOOL animating;

// 用于显示加载效果的渐变图层
@property (nonatomic, strong) CAGradientLayer *loadingLayer;

@end

@implementation LoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        self.layer.cornerRadius = 3.0;
        _animating = NO;// 未启动动画
 
        // 绘图
        [self drawLoadingLayer];
    }
    return self;
}

- (void)drawLoadingLayer
{
    CGSize size = self.bounds.size;
    CGPoint center = CGPointMake(size.width/2, size.height/2);// 圆心
    CGFloat radius = LoadingLayerWidth/2;// 半径
    CGFloat strokeWidth = 2.0;// 描边宽度
    CGFloat angleDelta = M_PI / 2;// 角度变化量

// 1.创建渐变图层
    // 初始化渐变图层
    _loadingLayer = [CAGradientLayer layer];
    _loadingLayer.frame = CGRectMake(center.x - LoadingLayerWidth/2, center.y - LoadingLayerWidth/2, LoadingLayerWidth, LoadingLayerWidth);
    [self.layer addSublayer:_loadingLayer];
    
    // 填充色不可用带透明度的颜色（会导致颜色叠加），要使用实色
    _loadingLayer.colors = @[(id)[UIColor whiteColor].CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor redColor].CGColor];
    _loadingLayer.locations = @[@0.0, @0.5, @1.0];// 关键位置
    _loadingLayer.startPoint = CGPointMake(0.5, 0.0);// 开始点
    _loadingLayer.endPoint = CGPointMake(0.5, 1.0);// 结束点
    _loadingLayer.type = kCAGradientLayerAxial;// 线性渐变
    
// 2.创建圆圈形状
    // 创建外部弧
    center = CGPointMake(radius, radius);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:angleDelta endAngle:angleDelta*4 clockwise:YES];
    
    // 添加右边弧
    CGFloat strokeRaduis = strokeWidth / 2;
    [maskPath addArcWithCenter:CGPointMake(center.x+radius-strokeRaduis, center.y) radius:strokeRaduis startAngle:0 endAngle:angleDelta*2 clockwise:YES];
    
    // 添加内部弧
    [maskPath addArcWithCenter:center radius:(radius-strokeWidth) startAngle:angleDelta*4 endAngle:angleDelta clockwise:NO];
    
    // 添加底边弧
    [maskPath addArcWithCenter:CGPointMake(center.x, center.y+radius-strokeRaduis) radius:strokeRaduis startAngle:-angleDelta endAngle:angleDelta clockwise:YES];
    
    // 完成路径绘制，闭合路径
    [maskPath closePath];// 注释掉好像也没影响
    
    // 添加路径到形状图层上，_loadingLayer没有path属性，只有mask属性
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = _loadingLayer.bounds;// 二者重合
    maskLayer.path = maskPath.CGPath;
    
    // 3.将形状图层作为渐变图层的遮罩，不加这句得到的只是个旋转的矩形
    _loadingLayer.mask = maskLayer;
}

// 展示视图动画
- (void)showAnimation
{
    // 透明度动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(0.0);// 初始值
    animation.toValue = @(1.0);// 结束值
    animation.removedOnCompletion = NO;// 完成后不移除
    animation.duration = 0.3;// 持续0.3秒
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];// 渐渐退出
    // 添加到视图图层中
    [self.layer addAnimation:animation forKey:@"showAnimation"];
}

// 隐藏视图动画
- (void)hideAnimation
{
    // 透明度动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(1.0);// 初始值
    animation.toValue = @(0.0);// 结束值
    animation.removedOnCompletion = NO;// 完成后不移除
    animation.duration = 0.3;// 持续0.3秒
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];// 渐渐退出
    // 添加到视图图层中
    [self.layer addAnimation:animation forKey:@"hideAnimation"];
}

// 加载视图动画
- (void)loadingAnimating
{
    // 绕Z轴旋转动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);// 初始值
    animation.toValue = @(M_PI*2);// 结束值
    animation.removedOnCompletion = NO;// 完成后不移除
    animation.repeatCount = HUGE_VALF;// 重复无限次
    animation.duration = 1.0;// 持续1秒
    // 添加到加载图层中
    [_loadingLayer addAnimation:animation forKey:@"loadingAnimating"];
}

// 开始动画
- (void)startAnimating
{
    // 已经在动画状态中则直接返回
    if (_animating)
    {
        return;
    }
    
    // 清除之前的旧动画
    [self cleanAnimations];
    
    // 设置为动画状态
    _animating = YES;
    // 不再隐藏视图
    self.hidden = NO;
    
    // 展示视图动画
    [self showAnimation];
    // 加载视图动画
    [self loadingAnimating];
}

// 停止动画
- (void)stopAnimating
{
    // 清除动画
    [self cleanAnimations];
    // 隐藏视图
    self.hidden = YES;
    // 设置为非动画状态
    _animating = NO;
}

// 清除动画
- (void)cleanAnimations
{
    [self.layer removeAnimationForKey:@"showAnimating"];// 移除显示动画
    [self.layer removeAnimationForKey:@"hideAnimating"];// 移除隐藏动画
    [_loadingLayer removeAnimationForKey:@"loadingAnimating"];// 移除加载动画
}

@end
