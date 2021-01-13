//
//  GestureRecognizerViewController.m
//  UIKitGrammarDemo
//
//  Created by 谢佳培 on 2020/10/30.
//

#import "GestureRecognizerViewController.h"

@interface GestureRecognizerViewController ()

@property (nonatomic, strong) UIView *gestureRecognizerView;// 用于手势识别的View
// 上一次缩放比例，默认为1
@property (nonatomic, assign) CGFloat lastScale;
// 最大缩放比例，默认为2
@property (nonatomic, assign) CGFloat maxScale;
// 最小缩放比例，默认为1
@property (nonatomic, assign) CGFloat minScale;

@end

@implementation GestureRecognizerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createGestureRecognizerView];
    [self tapGestureRecognizer];
}

- (void)createGestureRecognizerView
{
    self.gestureRecognizerView = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 314, 500)];
    self.gestureRecognizerView.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:self.gestureRecognizerView];
}

// Tap: 点击
- (void)tapGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    tap.numberOfTapsRequired = 2;// 设置轻拍次数
    tap.numberOfTouchesRequired = 2;// 设置手指字数

    [self.gestureRecognizerView addGestureRecognizer:tap];
}

- (void)tapView:(UITapGestureRecognizer *)sender
{
    // 改变testView的颜色
    self.gestureRecognizerView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    NSLog(@"点击改变testView的颜色");
}

// Swipe: 轻扫
- (void)swipeGestureRecognizer
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    swipe.numberOfTouchesRequired = 1;// 设置手指个数
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;// 设置轻扫方向(默认是从左往右)

    [self.gestureRecognizerView addGestureRecognizer:swipe];
}

- (void)swipeView:(UISwipeGestureRecognizer *)sender
{
    // 改变testView的颜色
    self.gestureRecognizerView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    NSLog(@"轻扫改变testView的颜色");
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"从左往右轻扫");
    }
}

// LongPress: 长按
- (void)longPressGestureRecognizer
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 2;// 最小长按时间
    
    [self.gestureRecognizerView addGestureRecognizer:longPress];
}

- (void)longPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)// 在什么时候触发事件
    {
        // 改变testView的颜色
        self.gestureRecognizerView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
        NSLog(@"长按改变testView的颜色");
    }
}

// Pan: 平移
- (void)panGestureRecognizer
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.gestureRecognizerView addGestureRecognizer:pan];
}

- (void)panView:(UIPanGestureRecognizer *)sender
{
    // 起始点
    CGPoint point = [sender translationInView:self.gestureRecognizerView];
    
    // 第一种移动方法:每次移动都是从原来的位置移动
    sender.view.transform = CGAffineTransformMakeTranslation(point.x, point.y);
    
    // 第二种移动方式:以上次的位置为标准(第二次移动加上第一次移动量)
    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, point.x, point.y);
    // 增量置为0
    [sender setTranslation:CGPointZero inView:sender.view];
    
    // 改变testView的颜色
    self.gestureRecognizerView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    
    NSLog(@"平移改变testView的颜色");
}

// ScreenEdgePan: 屏幕边缘平移
- (void)useScreenEdgePanGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *screenEdgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenEdgePanView:)];
    screenEdgePan.edges = UIRectEdgeLeft ;// 视图位置(屏幕边缘)
    [self.gestureRecognizerView addGestureRecognizer:screenEdgePan];
}

// 不走这个方法......
- (void)screenEdgePanView:(UIScreenEdgePanGestureRecognizer *)sender
{
    // 获取拖动的位置
    CGPoint point = [sender translationInView:sender.view];
    
    // 每次都以传入的translation为起始参照
    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, point.x, 0);
    
    // 设置当前拖动的位置
    [sender setTranslation:CGPointZero inView:sender.view];
    
    // 改变testView的颜色
    self.gestureRecognizerView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    
    if (sender.edges == UIRectEdgeLeft)
    {
        NSLog(@"从左边缘向右平移");
    }
}

// 获取屏幕边缘扇动手势
- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    
    if (self.view.gestureRecognizers.count > 0)
    {
        for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers)
        {
            NSLog(@"手势：%@",recognizer);
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    
    return screenEdgePanGestureRecognizer;
}

// Pinch: 捏合
- (void)pinchGestureRecognizer
{
    // 设置缩放比例
    self.lastScale = 1;
    self.minScale = 0.5;
    self.maxScale = 2;
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.gestureRecognizerView addGestureRecognizer:pinch];
}

- (void)pinchView:(UIPinchGestureRecognizer *)recognizer
{
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:// 缩放开始
        case UIGestureRecognizerStateChanged:// 缩放改变
        {
            CGFloat currentScale = [[self.gestureRecognizerView.layer valueForKeyPath:@"transform.scale"] floatValue];
            CGFloat newScale = recognizer.scale - self.lastScale + 1;
            newScale = MIN(newScale, self.maxScale / currentScale);
            newScale = MAX(newScale, self.minScale / currentScale);
            
            self.gestureRecognizerView.transform = CGAffineTransformScale(self.gestureRecognizerView.transform, newScale, newScale);
            self.lastScale = recognizer.scale;
            
            break;
        }
        case UIGestureRecognizerStateEnded:// 缩放结束
            self.lastScale = 1;
            break;
        default:
            break;
    }
}

// Rotation: 旋转
- (void)rotationGestureRecognizer
{
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationView:)];
    [self.gestureRecognizerView addGestureRecognizer:rotation];
}

- (void)rotationView:(UIRotationGestureRecognizer *)sender
{
    CGFloat rotationAngleInRadians = 0;// 旋转角度
    // 手势识别完成，保存旋转的角度
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        rotationAngleInRadians += sender.rotation;
    }
    // 将上一次角度加上本次旋转的角度作为本次旋转的角度
    self.view.transform = CGAffineTransformMakeRotation(rotationAngleInRadians + sender.rotation);
}

// 支持多个UIGestureRecongnizer共存
// 先接受到了手势事件，直接就处理而没有往下传递实际上就是两个手势共存的问题，先执行了UIScrollerView中包含的手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 滑动返回无法触发，说明UIScreenEdgePanGestureRecongnizer并没有接受到手势事件
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]  && [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
    {
        // 返回YES，手势事件会一直往下传递，不论当前层次是否对该事件进行响应
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
