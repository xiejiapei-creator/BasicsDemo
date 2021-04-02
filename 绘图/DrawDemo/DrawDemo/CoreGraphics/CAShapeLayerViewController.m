//
//  CAShapeLayerViewController.m
//  AnimationDemo
//
//  Created by 谢佳培 on 2020/9/28.
//

#import "CAShapeLayerViewController.h"

@implementation GeometryShapeLayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self createRing];
    }
    return self;
}

// 圆、三角形、矩形
- (void)createCircleTriangleRectangle
{
    // 创建圆的路径
    UIBezierPath *cyclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(30, 30) radius:20 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [cyclePath closePath];// 闭合路径，这里可有可无，圆已经连接完了
    
    // 创建形状图层
    CAShapeLayer *cycleLayer = [CAShapeLayer layer];
    cycleLayer.path = cyclePath.CGPath;// 路径为圆
    cycleLayer.strokeColor = [UIColor redColor].CGColor;// 红色描边
    cycleLayer.lineWidth = 10.0;// 线宽
    cycleLayer.fillColor = [UIColor clearColor].CGColor;// 空白填充
    cycleLayer.frame = CGRectMake(0, 0, 60, 60);// 相对于view
    // 添加到view图层中
    [self.layer addSublayer:cycleLayer];
    
    // 三角形的三个点
    CGPoint triangleTop = CGPointMake(30, 10);
    CGPoint triangleLeft = CGPointMake(10, 50);
    CGPoint triangleRight = CGPointMake(50, 50);
    
    // 创建三角形路径
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:triangleTop];// 起始点
    [trianglePath addLineToPoint:triangleLeft];// 连线
    [trianglePath addLineToPoint:triangleRight];// 连线
    [trianglePath closePath];// 这里必须闭合，否则空了一边没有连接
    
    // 创建形状图层
    CAShapeLayer *triangleLayer = [CAShapeLayer layer];
    triangleLayer.path = trianglePath.CGPath;// 路径为三角形
    triangleLayer.strokeColor = [UIColor blackColor].CGColor;// 黑色描边
    triangleLayer.lineWidth = 1.0;// 线宽
    triangleLayer.fillColor = [UIColor redColor].CGColor;
    triangleLayer.frame = CGRectMake(60, 0, 60, 60);
    [self.layer addSublayer:triangleLayer];
    
    // 矩形路径
    UIBezierPath *rectanglePath = [UIBezierPath bezierPath];
    [rectanglePath moveToPoint:CGPointMake(10, 10)];// 起始点
    [rectanglePath addLineToPoint:CGPointMake(10, 50)];// 连线
    [rectanglePath addLineToPoint:CGPointMake(50, 50)];// 连线
    [rectanglePath addLineToPoint:CGPointMake(50, 10)];// 连线
    [rectanglePath closePath];// 这里必须闭合，否则空了一边没有连接
    
    // 创建形状图层
    CAShapeLayer *rectangleLayer = [CAShapeLayer layer];
    rectangleLayer.path = rectanglePath.CGPath;// 路径为矩形
    rectangleLayer.strokeColor = [UIColor redColor].CGColor;// 红色描边
    rectangleLayer.lineWidth = 6.0;// 线宽
    rectangleLayer.fillColor = [UIColor yellowColor].CGColor;// 黄色填充
    rectangleLayer.frame = CGRectMake(120, 0, 60, 60);
    [self.layer addSublayer:rectangleLayer];
}

// 圆环
- (void)createRing
{
    self.backgroundColor = [UIColor clearColor];

    // 取最小一边的一半作为半径
    CGSize size = self.bounds.size;
    CGFloat radius = 0;
    if (size.width >= size.height)
    {
        radius = size.height / 2;
    }
    else
    {
        radius = size.width / 2;
    }
    
    // 圆点
    CGPoint center = CGPointMake(size.width/2, size.height/2);

// 上半圆环
    // 创建顶部路径
    UIBezierPath *topMaskPath = [UIBezierPath bezierPath];
    [topMaskPath moveToPoint:CGPointMake(0, center.y)];// 起始点
    [topMaskPath addArcWithCenter:center radius:radius startAngle:M_PI endAngle:M_PI*2 clockwise:YES];// 半圆
    [topMaskPath addLineToPoint:CGPointMake(center.x + radius - 20, center.y)];// 添加外环和内环的连接线
    [topMaskPath addArcWithCenter:center radius:radius-20 startAngle:M_PI*2 endAngle:M_PI clockwise:NO];// 半圆
    [topMaskPath closePath];// 闭合
    
    // 创建顶部形状图层作为mask
    CAShapeLayer *topMaskLayer = [CAShapeLayer layer];
    topMaskLayer.path = topMaskPath.CGPath;// 路径

    
    // 创建顶部图层
    CALayer *topLayer = [CALayer layer];
    topLayer.backgroundColor = [UIColor redColor].CGColor;// 红色背景
    topLayer.mask = topMaskLayer;// 形状图层作为mask
    topLayer.frame = self.bounds;
    [self.layer addSublayer:topLayer];

// 下半圆环
    // 创建底部路径
    UIBezierPath *bottomMaskPath = [UIBezierPath bezierPath];
    [bottomMaskPath moveToPoint:CGPointMake(0, center.y)];// 起始点
    [bottomMaskPath addArcWithCenter:center radius:radius startAngle:M_PI endAngle:0 clockwise:NO];// 半圆
    [bottomMaskPath addLineToPoint:CGPointMake(center.x+radius-20, center.y)];// 添加外环和内环的连接线
    [bottomMaskPath addArcWithCenter:center radius:radius-20 startAngle:0 endAngle:M_PI clockwise:YES];// 半圆
    [bottomMaskPath closePath];// 闭合
    
    // 创建底部形状图层作为mask
    CAShapeLayer *bottomMaskLayer = [CAShapeLayer layer];
    bottomMaskLayer.path = bottomMaskPath.CGPath;// 路径
    
    // 创建底部图层
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.backgroundColor = [UIColor redColor].CGColor;// 红色背景
    bottomLayer.mask = bottomMaskLayer;// 形状图层作为mask
    bottomLayer.frame = self.bounds;
    [self.layer addSublayer:bottomLayer];
}

@end

@interface CAShapeLayerViewController ()

@end

@implementation CAShapeLayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    [self.view addSubview:view];
    
    [self drawDashLine:view lineLength:5 lineSpacing:2 lineColor:[UIColor redColor]];
}

#pragma mark - 基本使用

// 普通曲线
- (void)commonCurve
{
    // 创建 path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint startPoint = CGPointMake(50, 200);
    CGPoint endPoint = CGPointMake(200, 200);
    CGPoint controlPoint1 = CGPointMake(100, 150);
    CGPoint controlPoint2 = CGPointMake(150, 300);
    [path moveToPoint:startPoint];
    [path addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];

    // 创建 shapeLayer
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc]init];
    [self.view.layer addSublayer:shapeLayer];
    shapeLayer.path = path.CGPath;

    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.lineWidth = 5;
}

// 普通直线
- (void)ordinaryStraightLine
{
    UIBezierPath *linePathTop = [UIBezierPath bezierPath];
    [linePathTop  moveToPoint:CGPointMake(0, 130)];
    [linePathTop  addLineToPoint:CGPointMake(400, 130)];

    CAShapeLayer *maskLayerTop = [CAShapeLayer layer];
    maskLayerTop.path = linePathTop.CGPath;
    
    maskLayerTop.strokeColor = [UIColor grayColor].CGColor;
    maskLayerTop.lineWidth = 10.0;
    // X、Y坐标起作用了，但是宽度和高度设置何值好像都没影响
    maskLayerTop.frame = CGRectMake(0, 125, 500, 10);

    [self.view.layer addSublayer:maskLayerTop];
}

// 圆点
- (void)dot
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = CGRectMake(30, 30, 10, 10);
    maskLayer.cornerRadius = 5;
    maskLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:maskLayer];
}

// 矩形
- (void)rectangle
{
    // X、Y坐标和宽高均起作用了
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:CGRectMake(90, 60, 150, 150)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = rectPath.CGPath;
    
    maskLayer.lineWidth = 10.0;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.strokeColor = [UIColor colorWithRed:88/255.0 green:185/255.0 blue:157/255.0 alpha:1].CGColor;
    
    // X、Y坐标起作用了，但是宽度和高度设置何值好像都没影响
    maskLayer.frame = CGRectMake(90, 60, 500, 500);
    
    [self.view.layer addSublayer:maskLayer];
}

// 单选按钮
- (void)radioButton
{
    // ☑️ 以maskLayer.frame作为自己的bounds来源
    UIBezierPath *checkPath = [UIBezierPath bezierPath];
    [checkPath moveToPoint:CGPointMake(7, 19)];
    [checkPath addLineToPoint:CGPointMake(15, 25)];
    [checkPath addLineToPoint:CGPointMake(25, 9)];
    
    // 圆
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = checkPath.CGPath;
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    maskLayer.lineWidth = 3.0;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    
    // 以checkButton.frame作为自己的bound来源
    // 宽、高对checkPath没影响，不影响按钮响应区域，但是改变了背景
    // 将cornerRadius设置为15，宽、高设置为30则产生了单选按钮效果
    maskLayer.frame = CGRectMake(0, 0, 300, 300);
    maskLayer.cornerRadius = 15;
    maskLayer.backgroundColor = [UIColor grayColor].CGColor;
    
    // 按钮
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    checkButton.frame = CGRectMake(50, 435, 80, 85);
    checkButton.backgroundColor = [UIColor redColor];
    [checkButton.layer addSublayer:maskLayer];
    [checkButton addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkButton];
}

- (void)changeColor
{
    NSLog(@"改变了颜色");
}

// 几何图形
- (void)createGeometryView
{    
    GeometryShapeLayerView *shapeView = [[GeometryShapeLayerView alloc] initWithFrame:CGRectMake(100, 380, 160, 60)];
    [self.view addSubview:shapeView];
}

// 通过CAShapeLayer方式绘制虚线
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];// 大小
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];// 位置
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];// 填充颜色
    
    // 设置虚线颜色
    [shapeLayer setStrokeColor:lineColor.CGColor];
    // 设置虚线宽度（其实是高度）
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    
    // 设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);// 起点
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);// 终点
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    // 把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

@end




