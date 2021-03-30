//
//  DrawRectViewController.m
//  AnimationDemo
//
//  Created by 谢佳培 on 2020/9/29.
//

#import "DrawRectViewController.h"
#import <Masonry/Masonry.h>

#pragma mark - 画线

@implementation DrawLineView

// 只有在drawRect方法中才能拿到图形上下文，才可以画图
- (void)drawRect:(CGRect)rect
{
    [self drawRect:rect];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _isTop = NO;
        _isBottom = NO;
    }
    return self;
}

// 一条直线
- (void)drawStraightLine
{
    // 获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
// 一、直接使用图形上下文画图
    // 描述路径
    CGContextMoveToPoint(context, 10, 19);// 起始点
    CGContextAddLineToPoint(context, 100, 65);// 添加线
    
    // 完成路线绘制
    CGContextStrokePath(context);
    
// 二、使用图形上下文+CGPathRef画线
    // 使用path来画线
    CGMutablePathRef path = CGPathCreateMutable();
    // 添加点
    CGPathMoveToPoint(path, NULL, 34, 23);
    CGPathAddLineToPoint(path, NULL, 100, 43);
    // 将path添加到图像上下文上
    CGContextAddPath(context, path);
    // 渲染上下文
    CGContextStrokePath(context);
    
// 三、可以只使用贝塞尔曲线画线，不获取图形上下文，因为在底层系统已经给封装了
    // 1.创建路径
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    // 2.画线
    [bezierPath moveToPoint:CGPointMake(80, 45)];
    [bezierPath addLineToPoint:CGPointMake(150, 88)];
    // 3.渲染绘制
    [bezierPath stroke];
    
// 四、同时使用图形上下文+贝塞尔曲线画线
    // 使用贝塞尔曲线和图形上下文画图
     UIBezierPath *contextPath = [UIBezierPath bezierPath];
     [contextPath moveToPoint:CGPointZero];
     [contextPath addLineToPoint:CGPointMake(233, 69)];
    //这个是C语言的写法，必须使用path.CGPath，否则无效
     CGContextAddPath(context, contextPath.CGPath);
     CGContextStrokePath(context);
}

// 相交直线
- (void)drawIntersectingLines
{
    // 1.获取图形上文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 2.绘制路径，并且将其添加到图形上下文
    CGContextMoveToPoint(context,123, 45);// 起始点
    CGContextAddLineToPoint(context, 45, 80);// 添加一根线
    CGContextAddLineToPoint(context, 223, 159);// 添加另一根线

    // 3.设置路径属性
    [[UIColor greenColor] set];// 设置颜色，这种设置方式就不用考虑实线还是填充图形了
    CGContextSetLineWidth(context, 10);// 设置线的宽度
    CGContextSetLineJoin(context, kCGLineJoinMiter);// 设置链接处的链接类型
    CGContextSetLineCap(context, kCGLineCapButt);// 设置线的头部样式

    // 4.渲染绘制
    CGContextStrokePath(context);
}

// 两条不相交的线段
- (void)drawTwoLine
{
    // 设置红色线段
    UIBezierPath *redPath = [UIBezierPath bezierPath];
    [redPath moveToPoint:CGPointMake(12, 49)];
    [redPath addLineToPoint:CGPointMake(68, 34)];
    [redPath setLineWidth:3];
    [[UIColor redColor] set];
    [redPath stroke];

    // 设置绿色线段
    UIBezierPath *greenPath = [UIBezierPath bezierPath];
    [greenPath moveToPoint:CGPointMake(145, 167)];
    [greenPath addLineToPoint:CGPointMake(98, 34)];
    [greenPath setLineWidth:10];
    [[UIColor greenColor] set];
    [greenPath setLineCapStyle:kCGLineCapRound];
    [greenPath stroke];
}

// 绘制一条曲线
- (void)drawCurve
{
    // 获取图形上文
    CGContextRef context = UIGraphicsGetCurrentContext();

    // 设置起点
    CGContextMoveToPoint(context, 10, 10);
    
    // 需要图形上下文中配置要突出点的x和y值以及曲线结束点的x和y值
    CGContextAddQuadCurveToPoint(context, 50, 50, 100, 10);

    // 设置颜色
    [[UIColor redColor] set];

    // 渲染图层
    CGContextStrokePath(context);
}

// 绘制点线
- (void)drawDotLine
{
    // 获取图形上文
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);// 压入上下文
    
    // 设置线属性
    UIColor *lineColor = [UIColor redColor];
    CGFloat height = 10;
    
    CGContextSetLineWidth(context, 10);// 点的高度
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);// 红线
    CGFloat lengths[] = {3, 2};// 表示先绘制3个点，再跳过2个点，如此反复
    // phase参数表示在第一个虚线绘制的时候跳过多少个点，这里为0
    CGContextSetLineDash(context, 10, lengths, 2);// 2表示lengths数组的长度
    
    // 绘制线
    CGPoint left = CGPointMake(20, height/2);
    CGPoint right = CGPointMake(200, height/2);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:left];// 起始点
    [path addLineToPoint:right];// 结束点
    
    // 将线添加到上下文
    CGContextAddPath(context, path.CGPath);
    
    // 渲染绘制
    CGContextStrokePath(context);
}

// 绘制温度计
- (void)drawThermometerLine
{
    // 获取图形上文
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);// 压入上下文
    
    // 配置线条属性
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);// 红线
    CGContextSetLineWidth(context, 5.0);// 线宽
    
    CGFloat height = self.bounds.size.height;
    
    if (!_isTop)// 线帽在底部
    {
        CGPoint top = CGPointMake(150, 0);// 线顶
        CGPoint cycleTop = CGPointMake(150, 16 - 6 - 5);// 线帽顶
        
        // 创建线条路径
        UIBezierPath *topPath = [UIBezierPath bezierPath];
        [topPath moveToPoint:top];
        [topPath addLineToPoint:cycleTop];
        CGContextAddPath(context, topPath.CGPath);
    }
    
    if (!_isBottom)// 线帽在顶部
    {
        CGPoint cycleBottom = CGPointMake(150, 16 + 6 + 5);// 线帽底
        CGPoint bottom = CGPointMake(150, height);// 线底
        
        // 创建线条路径
        UIBezierPath *bottomPath = [UIBezierPath bezierPath];
        [bottomPath moveToPoint:cycleBottom];
        [bottomPath addLineToPoint:bottom];
        CGContextAddPath(context, bottomPath.CGPath);
    }
    
    // 渲染绘制线条
    CGContextStrokePath(context);
    
    // 画线帽
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);// 黄色
    CGPoint center = CGPointMake(150, 16);// 圆心
    
    UIBezierPath *cyclePath = [UIBezierPath bezierPath];
    [cyclePath moveToPoint:CGPointMake(center.x, center.y+6)];// 圆心
    [cyclePath addArcWithCenter:center radius:6 startAngle:0 endAngle:M_PI*2 clockwise:YES];// 圆
    [cyclePath closePath];// 闭合
    CGContextAddPath(context, cyclePath.CGPath);
    CGContextFillPath(context);
}

// 温度计上下颠倒
- (void)isTop:(BOOL)isTop isBottom:(BOOL)isBottom
{
    _isTop = isTop;
    _isBottom = isBottom;
    [self setNeedsDisplay];
}

@end

#pragma mark - 几何图形

@implementation DrawGeometryView

- (void)drawRect:(CGRect)rect
{
    [self drawSector];
}

// 三角形、圆、圆饼、心
- (void)collectionView
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    // timeline部分
    UIColor *timeLineColor = [UIColor redColor];
    
    //============================================
    // 描边
    CGContextSetStrokeColorWithColor(context, timeLineColor.CGColor);// 描边颜色
    CGContextSetLineWidth(context, 2.0);// 描边线宽
    
// 三角形
    CGPoint triangleTop = CGPointMake(50, 10);// 顶点
    CGPoint triangleLeft = CGPointMake(0, 60);// 左点
    CGPoint triangleRight = CGPointMake(100, 60);// 右点
    
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];// 创建路径
    [trianglePath moveToPoint:triangleTop];// 起始点
    [trianglePath addLineToPoint:triangleLeft];// 左边
    [trianglePath addLineToPoint:triangleRight];// 右边
    [trianglePath closePath];// 闭合
    
    CGContextAddPath(context, trianglePath.CGPath);// 添加路径
    
// 圆
    CGPoint strokeCenter = CGPointMake(150, 30);// 圆心
    UIBezierPath *strokeCyclePath = [UIBezierPath bezierPathWithArcCenter:strokeCenter radius:25 startAngle:0 endAngle:M_PI*2 clockwise:YES];// 圆形
    [strokeCyclePath closePath];// 闭合
    
    CGContextAddPath(context, strokeCyclePath.CGPath);// 添加路径
    
    // 描边
    CGContextStrokePath(context);
    
    //==============================
    // 填充
    CGContextSetFillColorWithColor(context, timeLineColor.CGColor);// 填充颜色
    
// 圆饼
    CGPoint fillCenter = CGPointMake(220, 30);// 圆心
    UIBezierPath *fillCyclePath = [UIBezierPath bezierPathWithArcCenter:fillCenter radius:25 startAngle:0 endAngle:M_PI*2 clockwise:YES];// 圆形
    [fillCyclePath closePath];// 闭合
    
    CGContextAddPath(context, fillCyclePath.CGPath);// 添加路径
    
// 心：双圆弧+双贝塞尔曲线
    CGPoint startPoint = CGPointMake(260, 30);// 起始点
    
    UIBezierPath *heartPath = [UIBezierPath bezierPath];// 创建路径
    [heartPath moveToPoint:startPoint];// 起始点
    [heartPath addArcWithCenter:CGPointMake(280, 30) radius:20 startAngle:-M_PI endAngle:0 clockwise:YES];// 圆弧1
    [heartPath addArcWithCenter:CGPointMake(320, 30) radius:20 startAngle:-M_PI endAngle:0 clockwise:YES];// 圆弧2
    [heartPath addCurveToPoint:CGPointMake(300, 80) controlPoint1:CGPointMake(330, 60) controlPoint2:CGPointMake(330, 60)];// 贝塞尔曲线1
    [heartPath addCurveToPoint:startPoint controlPoint1:CGPointMake(270, 60) controlPoint2:CGPointMake(270, 60)];// 贝塞尔曲线2
    [heartPath closePath];// 闭合
    CGContextAddPath(context, heartPath.CGPath);// 添加路径
    
    // 填充
    CGContextFillPath(context);
}

// 圆角矩形
- (void)drawRoundedRectangle
{
    // 绘制一个圆角矩形
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 10, 100, 40) cornerRadius:5];
    [[UIColor orangeColor] set];
    [path stroke];// 设置边框的颜色

    // 绘制一个圆角矩形
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 110, 100, 40) cornerRadius:5];
    [[UIColor greenColor] set];
    [path2 fill];// fill填充内部的颜色，必须是封闭的图形

    // 绘制一个圆形（不规范的绘制法：圆角直径是正方形的边长）
    UIBezierPath *path3 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(140, 10, 100, 100) cornerRadius:50];
    [[UIColor cyanColor] set];
    [path3 fill];
}

// 弧线
- (void)drawArc
{
    /** 绘制弧度曲线
     *  ArcCenter 曲线中心
     *  radius       半径
     *  startAngle 开始的弧度
     *  endAngle 结束的弧度
     *  clockwise YES顺时针，NO逆时针
     */
    UIBezierPath *greenPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:14 startAngle:0 endAngle:M_PI clockwise:YES];
    [[UIColor greenColor] set];
    [greenPath stroke];

    // 结束角度如果是 M_PI * 2 就是一个圆
    // M_PI是180度 M_PI_2是90度
    UIBezierPath *purplePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(240, 140) radius:40 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [[UIColor purpleColor] set];
    [purplePath fill];

    // 绘制115度角的圆弧
    // 这里的角度都是弧度制度，如果我们需要15°，可以用15°/180°*π得到
    UIBezierPath *orangePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(160, 100) radius:20 startAngle:0 endAngle:115/360.0*(M_PI *2) clockwise:NO];
    [[UIColor orangeColor] set];
    [orangePath stroke];
}

// 扇形
- (void)drawSector
{
    // 获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 绘制曲线
    CGFloat centerX = 100;
    CGFloat centerY = 100;
    CGFloat radius = 30;
    
    // 添加一个点
    CGContextMoveToPoint(context, centerX, centerY);
    // 添加一个圆弧
    CGContextAddArc(context, centerX, centerY, radius, M_PI, M_PI_2, NO);
    // 关闭线段
    CGContextClosePath(context);
    // 渲染
    CGContextStrokePath(context);
}

@end

#pragma mark - 功能块

@implementation DrawFunctionView

- (void)drawRect:(CGRect)rect
{
    [self drawStar];
}

#pragma mark - 进度条

// 多次调用drawRect
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    // 要想调用drawRect:(CGRect)rect方法，必须要使用setNeedsDisplay，否则无效
    [self setNeedsDisplay];
}

// 下载进度
- (void)drawDownloadProgress
{
    CGFloat radius = self.frame.size.height * 0.5 - 10;// 半径
    CGFloat endAadius = self.progress * M_PI * 2 - M_PI_2;// 结束点
    
    // 创建路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius+5,radius+5) radius:radius-5 startAngle:-M_PI_2 endAngle:endAadius clockwise:YES];// 弧线
    path.lineWidth = 10;// 线宽
    path.lineCapStyle = kCGLineCapRound;// 圆角
    [[UIColor redColor] set];// 红色
    [path stroke];// 绘制
}

#pragma mark - 饼状图

// 画饼状图
- (void)drawPieChart
{
    CGPoint center = CGPointMake(100, 100);// 圆心
    CGFloat radius = 50;// 半径
    CGFloat startAngle = 0;// 开始角度
    CGFloat endAngle = 0;// 结束角度
    
    for (int i = 0; i < self.nums.count; i++)
    {
        NSNumber *data = self.nums[i];// 各块披萨上面的数字
        
        // startAngle跳转到最新的endAngle的位置
        startAngle = endAngle;
        
        // 重新计算endAngle的最新位置
        endAngle = startAngle + [data floatValue]/self.total * 2 * M_PI;
        
        // 路径
        UIBezierPath *path  = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        
        // 连接弧形和圆心
        [path addLineToPoint:center];
        
        // 填充随机颜色
        CGFloat randRed = arc4random_uniform(256)/255.0;
        CGFloat randGreen = arc4random_uniform(256)/255.0;
        CGFloat randBlue = arc4random_uniform(256)/255.0;
        UIColor *randomColor = [UIColor colorWithRed:randRed green:randGreen blue:randBlue alpha:1.0];
        [randomColor set];
        [path fill];
    }
}

// 所有披萨的数字和
- (NSInteger)total
{
    if (_total == 0)
    {
        for (int j = 0; j < self.nums.count; j++)
        {
            _total += [self.nums[j] integerValue];
        }
    }
    return _total;
}

// 各块披萨上面的数字
-(NSArray *)nums
{
    if (!_nums)
    {
        _nums = @[@23,@34,@33,@13,@30,@44,@66];
    }
    return _nums;
}

#pragma mark - 柱状图

- (NSArray *)barNums
{
    if (!_barNums)
    {
        _barNums = @[@23,@34,@93,@2,@55,@46];
    }
    return _barNums;
}

- (void)drawBarChart:(CGRect)rect
{
    // 获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 两个柱状间距
    CGFloat margin = 30;
    
    // 每个柱状宽度 = （总宽度 - 柱状间距的宽度和）/ 柱状个数
    CGFloat width = (rect.size.width - (self.barNums.count + 1) * margin) / self.barNums.count;
    
    for (int i = 0; i < self.barNums.count; i++)
    {
        // 柱X坐标
        CGFloat x = margin + (width + margin) * i;
        
        // 计算柱Y坐标 = 总高度 - 柱状高度
        CGFloat num = [self.barNums[i] floatValue] / 100;// 柱所代表的数字
        CGFloat y = rect.size.height * (1 - num);// y坐标
        CGFloat height = rect.size.height * num;// 柱高度
        
        // 绘柱图
        CGRect barRect =  CGRectMake(x, y, width, height);
        CGContextAddRect(context,barRect);
        
        // 填充随机颜色
        CGFloat randRed = arc4random_uniform(256)/255.0;
        CGFloat randGreen = arc4random_uniform(256)/255.0;
        CGFloat randBlue = arc4random_uniform(256)/255.0;
        UIColor *randomColor = [UIColor colorWithRed:randRed green:randGreen blue:randBlue alpha:1.0];
        [randomColor set];

        CGContextFillPath(context);
    }
}

#pragma mark - 评分星星

// 画星星
- (void)drawStar
{
    CGFloat innerRadius = self.starRadius*sin(M_PI/10)/cos(M_PI/5);
    
    for (int i = 0; i < self.defaultNumber; i++)
    {
        // 创建星星视图
        UIView *starView = [[UIView alloc] initWithFrame:CGRectMake(2*self.starRadius*cos(M_PI/10)*i, 0, 2*self.starRadius*cos(M_PI/10), self.starRadius+self.starRadius*cos(M_PI/10))];
        
        // 创建星星形状图层
        CAShapeLayer *starMask = [CAShapeLayer layer];
        
        // 第一个点
        CGPoint firstPoint = CGPointMake(self.starRadius, 0);
        // 第二个点
        CGPoint secondPoint = CGPointMake(self.starRadius+innerRadius*sin(M_PI/5), self.starRadius - innerRadius*cos(M_PI/5));
        // 第三个点
        CGPoint thirdPoint = CGPointMake(self.starRadius*cos(M_PI/10)+self.starRadius, self.starRadius-self.starRadius*sin(M_PI/10));
        // 第四个点
        CGPoint forthPoint = CGPointMake(self.starRadius + innerRadius*sin(3*M_PI/10), self.starRadius + innerRadius*cos(3*M_PI/10));
        // 第五个点
        CGPoint fifthPoint = CGPointMake(self.starRadius*cos(M_PI*3/10)+self.starRadius, self.starRadius+self.starRadius*sin(M_PI*3/10));
        // 第六个点
        CGPoint sixthPoint = CGPointMake(self.starRadius, self.starRadius+innerRadius);
        // 第七个点
        CGPoint seventhPoint = CGPointMake(self.starRadius-self.starRadius*cos(M_PI*3/10), self.starRadius+self.starRadius*sin(M_PI*3/10));
        // 第八个点
        CGPoint eighthPoint = CGPointMake(self.starRadius - innerRadius*sin(3*M_PI/10), self.starRadius + innerRadius*cos(3*M_PI/10));
        // 第九个点
        CGPoint ninethPoint = CGPointMake(self.starRadius-self.starRadius*cos(M_PI/10), self.starRadius-self.starRadius*sin(M_PI/10));
        // 第十个点
        CGPoint tenthPoint = CGPointMake(self.starRadius - innerRadius*sin(M_PI/5), self.starRadius - innerRadius*cos(M_PI/5));
        
        // 创建路径图
        UIBezierPath *starMaskPath = [UIBezierPath bezierPath];
        [starMaskPath moveToPoint:firstPoint];
        [starMaskPath addLineToPoint:secondPoint];
        [starMaskPath addLineToPoint:thirdPoint];
        [starMaskPath addLineToPoint:forthPoint];
        [starMaskPath addLineToPoint:fifthPoint];
        [starMaskPath addLineToPoint:sixthPoint];
        [starMaskPath addLineToPoint:seventhPoint];
        [starMaskPath addLineToPoint:eighthPoint];
        [starMaskPath addLineToPoint:ninethPoint];
        [starMaskPath addLineToPoint:tenthPoint];
        [starMaskPath closePath];// 闭合路径
        starMask.path = starMaskPath.CGPath;// 星星形状图层的路径
        starMask.strokeColor = _starColor.CGColor;// 绘边颜色
        
        // 填充颜色
        if (i < self.starWithColorNumber)
        {
            starMask.fillColor = _starColor.CGColor;
        }
        else
        {
            starMask.fillColor = UIColor.whiteColor.CGColor;
        }
        
        // 添加星星形状图层到视图
        [starView.layer addSublayer:starMask];
        [self addSubview:starView];
    }
}

@end

#pragma mark - 文字和图片

@implementation DrawImageAndText

- (void)drawRect:(CGRect)rect
{
    [self drawSnow:rect];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createSnowTimer];
    }
    return self;
}

// 绘制图片
- (void)drawImage:(CGRect)rect
{
    // 1.用矩形去填充一个区域
    UIRectFill(rect);
    
    // 2.绘制一个矩形的边框
    UIRectFrame(rect);
    
    // 3.剪切图片，超出的图片位置都要剪切掉！必须要在绘制之前写，否则无效
    UIRectClip(CGRectMake(20, 20, 400, 400));
    
    // 4.创建图片
    UIImage *image = [UIImage imageNamed:@"luckcoffee.JPG"];
    // 在什么范围下
    [image drawInRect:rect];
    // 在哪个位置开始画
    //[image drawAtPoint:CGPointMake(10, 10)];
    // 平铺
    //[image drawAsPatternInRect:rect];
}

// 绘制文字
- (void)drawText
{
    NSString *str = @"遂以为九天之上，有诸般神灵，九幽之下，亦是阴魂归处，阎罗殿堂。";
    
    // 设置文字的属性
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[NSFontAttributeName] = [UIFont systemFontOfSize:40];// 字号
    paras[NSForegroundColorAttributeName] = [UIColor redColor];// 红色字体
    paras[NSStrokeColorAttributeName] = [UIColor blackColor];// 橘色描边
    paras[NSStrokeWidthAttributeName] = @3;// 橘色宽度

    // 创建阴影对象
    NSShadow *shodow = [[NSShadow alloc] init];
    shodow.shadowColor = [UIColor blueColor];// 阴影颜色
    shodow.shadowOffset = CGSizeMake(5, 6);// 阴影偏移
    shodow.shadowBlurRadius = 4;// 阴影模糊半径
    paras[NSShadowAttributeName]  = shodow;// 阴影属性
    
    // 富文本
    [str drawAtPoint:CGPointZero withAttributes:paras];
}

#pragma mark - 雪花飘动

// 每秒计时器都会调用
- (void)drawSnow:(CGRect)rect
{
    // 设置下雪的动画
    UIImage *image = [UIImage imageNamed:@"雪花.jpg"];
    
    // 全局变量，每次+10
    _snowY += 10;
    
    // 定点绘图
    [image drawAtPoint:CGPointMake(150, _snowY)];

    // 置0回到开头
    if (_snowY >= rect.size.height)
    {
        _snowY = 0;
    }
}

// 如果在绘图的时候需要用到定时器，通常使用CADisplayLink
// NSTimer很少用于绘图，因为调度优先级比较低，并不会准时调用
- (void)createSnowTimer
{
    // 创建定时器
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeChange)];
    
    // 添加到主运行循环
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

// CADisplayLink:每次屏幕刷新的时候就会调用，屏幕一般一秒刷新60次
- (void)timeChange
{
    [self setNeedsDisplay];
}

#pragma mark - 编辑图片

// 压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // 开启一个图片上下文
    UIGraphicsBeginImageContext(newSize);

    // 这里就是不同的部分：如压缩图片只需要将旧图片按照新尺寸绘制即可，无需获取当前的上下文
    // CGContextRef context = UIGraphicsGetCurrentContext();
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];

    // 从上下文当中取出新图片
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    // 返回新图片
    return newImage;
}

@end

#pragma mark - 修改图形

@implementation DrawEditView

- (void)drawRect:(CGRect)rect
{
    [self drawEllipse];
}

// 修改椭圆
- (void)drawEllipse
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 画一个椭圆
    CGPathRef path = CGPathCreateWithEllipseInRect(CGRectMake(0, 0, 200, 100),nil);
    [[UIColor redColor] set];// 红色

    // 偏移
    CGContextTranslateCTM(context, 150, 10);
    // 旋转
    CGContextRotateCTM(context, M_PI_4);
    // 缩放
    CGContextScaleCTM(context, 0.25, 2);

    // 绘图
    CGContextAddPath(context, path);
    CGContextFillPath(context);
}

@end

@interface DrawRectViewController ()

@property (nonatomic, strong) DrawFunctionView *drawView;
@property (nonatomic, strong) DrawFunctionView *star;
@property (nonatomic, strong) NSArray *starArray;
@property (nonatomic, assign) CGFloat starViewHeight;
@property (nonatomic, assign) CGFloat starViewWidth;

@end

@implementation DrawRectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createStarView];
}

- (void)createView
{
    DrawLineView *drawView = [[DrawLineView alloc] initWithFrame:CGRectZero];
    drawView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:drawView];
    [drawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.height.equalTo(@200);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    // 进度条Demo
    // self.drawView = drawView;
}

// 画评分星星
- (void)createStarView
{
    int starRadius = 30;// 外接圆半径
    int defaultNumber = 5;// 默认画五个星
    
    self.star = [[DrawFunctionView alloc] initWithFrame:CGRectZero];
    self.starViewHeight = starRadius+starRadius * cos(M_PI/10);// 星星高度
    self.starViewWidth = 2 * defaultNumber*starRadius * cos(M_PI/10);// 星星宽度
    self.star.starColor = [UIColor redColor];// 描边颜色
    self.star.starWithColorNumber = 2;// 有几颗星星需要填充颜色
    self.star.starRadius = starRadius;// 星星半径
    self.star.defaultNumber = defaultNumber;// 默认画五个星
    
    self.star.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.star];
    [self.star mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@300);
        make.center.equalTo(self.view);
    }];
}

// 压缩图片
- (void)createCompressView:(DrawImageAndText *)drawView
{
    UIImage *image = [drawView imageWithImageSimple:[UIImage imageNamed:@"luckcoffee.JPG"] scaledToSize:CGSizeMake(100, 100)];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(drawView.mas_top).offset(-100);
        make.height.equalTo(@200);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@200);
    }];
}

// 进度条
- (void)createProgressView:(DrawFunctionView *)drawView
{
    UISlider *progressView = [[UISlider alloc] init];
    progressView.minimumValue = 0;
    progressView.maximumValue = 1;
    progressView.value = 0;
    [progressView addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(drawView.mas_top).offset(-100);
        make.height.equalTo(@50);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@200);
    }];
}

- (void)changeProgress:(id)sender
{
    if ([sender isKindOfClass:[UISlider class]])
    {
        UISlider *slider = sender;
        self.drawView.progress = slider.value;
    }
}

@end



