//
//  ViewController.m
//  BasicGrammarDemo
//
//  Created by 谢佳培 on 2020/9/28.
//

#import "ViewController.h"
#import "HowToUseViewController.h"
#import <Masonry/Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSubviews];
}

- (void)createSubviews
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50.f, 820.f, 300, 50.f)];
    [button addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"跳转到下页" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.f;
    button.clipsToBounds = YES;
    button.layer.borderWidth = 1.f;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:button];
}

- (void)nextPage
{
    [self createBackBarButton];
    //  [self createActivityIndicatorView];
    
    HowToUseViewController *vc = [[HowToUseViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createBackBarButton
{
    // 自定义后退按钮的文字和颜色
    // 如果不想显示文字，直接""，就会单独显示一个系统的返回箭头图标
    // 必须放在触发push的那个页面才起作用
    // 设置返回按钮的属性
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    NSMutableDictionary *backTextAttrs = [NSMutableDictionary dictionary];
    backTextAttrs[NSFontAttributeName] = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:20];// 字号
    [backItem setTitleTextAttributes:backTextAttrs forState:UIControlStateHighlighted];// 高亮状态
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}
  

@end
