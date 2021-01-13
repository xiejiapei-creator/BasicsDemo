//
//  ControlViewController.m
//  UIKitGrammarDemo
//
//  Created by 谢佳培 on 2020/10/30.
//

#import "ControlViewController.h"
#import <Masonry/Masonry.h>

@interface ControlViewController ()

@end

@implementation ControlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSliderView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 因为跳转页面时，警告框或者键盘不能再出现
    [self.view endEditing:YES];
}

// 创建滑条视图
- (void)createSliderView
{
    UISlider *horizontalSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    
    horizontalSlider.minimumValue = 10;
    horizontalSlider.maximumValue = 100;
    [horizontalSlider addTarget:self action:@selector(horizontalSliderChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:horizontalSlider];
    [horizontalSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.height.equalTo(@44);
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
    }];
    
    UISlider *verticalSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    
    // 旋转90度
    CGAffineTransform transform = verticalSlider.transform;
    transform = CGAffineTransformRotate(transform, -M_PI/2);
    verticalSlider.transform = transform;
    
    verticalSlider.minimumValue = 10;
    verticalSlider.maximumValue = 100;
    [verticalSlider addTarget:self action:@selector(verticalSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:verticalSlider];
    
    [verticalSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(280);
        make.height.equalTo(@44);
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
    }];
}

- (void)horizontalSliderChanged:(id)sender
{
    UISlider *slider = sender;
    NSLog(@"水平滑条值改变：%f", slider.value);
}

- (void)verticalSliderChanged:(id)sender
{
    UISlider *slider = sender;
    NSLog(@"垂直滑条值改变： %f", slider.value);
}

// 创建SegmentedControl视图
- (void)createSegmentedControl
{
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"item1", @"item2", @"item3"]];
    
    segmentControl.selectedSegmentIndex = 1;
    
    [segmentControl addTarget:self action:@selector(segmentControlChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];
    
    [segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(60);
        make.height.equalTo(@44);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-100);
    }];
}

- (void)segmentControlChanged:(id)sender
{
    UISegmentedControl *segmentControl = sender;
    NSLog(@"segmentControl值改变:%@", @(segmentControl.selectedSegmentIndex));
}

// 创建开关视图
- (void)createSwitchView
{
    UISwitch *switcher = [[UISwitch alloc] initWithFrame:CGRectZero];
    [switcher addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switcher];
    
    
    [switcher mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(120);
        make.height.equalTo(@44);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.equalTo(@100);
    }];
}

- (void)switchChanged:(UISwitch *)sender
{
    
    UISwitch *switcher = sender;
    NSLog(@"开关改变了：%@", @(switcher.on));
}

// 创建指示器视图
- (void)createActivityIndicatorView
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    
    // 只能设置中心，不能设置大小
    activityIndicator.center = CGPointMake(200.0f, 200.0f);
    // 改变圈圈的颜色为红色
    activityIndicator.color = [UIColor redColor];
    
    // 开始旋转
    [activityIndicator startAnimating];
    // 结束旋转
    [activityIndicator stopAnimating];
    
    // 添加指示器到导航栏
    self.navigationItem.titleView = activityIndicator;
    self.navigationItem.prompt =  @"正在使出吃奶的劲加载中...";
    
    // 停止指示器控件本应该调用 stopAnimating 方法，但放在导航栏项目中的活动指示器控件有所不同
    // 要移除这个控件，让原来的title内容显示出来
    self.navigationItem.titleView = nil;
    self.navigationItem.prompt = nil;
    
    [self.view addSubview:activityIndicator];
}

@end
