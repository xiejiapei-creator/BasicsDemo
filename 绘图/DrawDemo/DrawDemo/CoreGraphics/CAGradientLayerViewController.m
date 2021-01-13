//
//  CAGradientLayerViewController.m
//  AnimationDemo
//
//  Created by 谢佳培 on 2020/9/29.
//

#import "CAGradientLayerViewController.h"

@implementation GradientLayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createSubViews];
    }
    return self;
}

// 添加子视图
- (void)createSubViews
{
    // 从左到右红蓝渐变
    CAGradientLayer *leftToRightGradientLayer = [CAGradientLayer layer];
    leftToRightGradientLayer.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor blueColor].CGColor];// 红蓝
    leftToRightGradientLayer.startPoint = CGPointMake(0, 0.5);// 开始位置
    leftToRightGradientLayer.endPoint = CGPointMake(1, 0.5);// 结束位置
    leftToRightGradientLayer.frame = CGRectMake(0, 0, 100, 100);
    [self.layer addSublayer:leftToRightGradientLayer];
    
    // 多色对角线渐变
    CAGradientLayer *multiGradientLayer = [CAGradientLayer layer];
    multiGradientLayer.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor blueColor].CGColor, (id)[UIColor yellowColor].CGColor];// 红蓝黄
    multiGradientLayer.locations = @[@0, @0.5, @1];// 控制渐变发生的位置
    multiGradientLayer.startPoint = CGPointMake(0, 0);// 开始点
    multiGradientLayer.endPoint = CGPointMake(1, 1);// 结束点
    multiGradientLayer.frame = CGRectMake(110, 0, 100, 100);
    [self.layer addSublayer:multiGradientLayer];
    
    // 以圆心做渐变
    CAGradientLayer *radialGradientLayer = [CAGradientLayer layer];
    radialGradientLayer.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor blueColor].CGColor];// 红蓝
    radialGradientLayer.type = kCAGradientLayerRadial;// 以圆心做渐变
    radialGradientLayer.frame = CGRectMake(220, 0, 100, 100);
    radialGradientLayer.startPoint = CGPointMake(.5, .5);
    radialGradientLayer.endPoint = CGPointMake(.0, 1);
    [self.layer addSublayer:radialGradientLayer];
}

@end

@implementation CAGradientLayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GradientLayerView *gradientView = [[GradientLayerView alloc] initWithFrame:CGRectMake(10, 460, 400, 100)];
    [self.view addSubview:gradientView];
}

@end
