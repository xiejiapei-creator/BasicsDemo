//
//  HowToUseViewController.m
//  UIKitGrammarDemo
//
//  Created by 谢佳培 on 2020/10/29.
//

#import "HowToUseViewController.h"
#import "ViewController.h"

@interface HowToUseViewController ()

@end

@implementation HowToUseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNavigationController];
}

#pragma mark - UINavigationController

- (void)createNavigationController
{
    self.navigationItem.title = @"详情界面";
    
    // 使用图片作为导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"luckcoffee.JPG"]];
    
    // 导航栏右边按钮添加文本
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.rightBarButtonItems = @[item,item];// 数组
    
    // 导航栏右边按钮添加图片后仍然使按钮保持原来的系统颜色
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"luckcoffee.JPG"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // 设置导航栏标题的属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor redColor];// 字体颜色
    textAttrs[NSFontAttributeName] = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:18];// 字号
    self.navigationController.navigationBar.titleTextAttributes = textAttrs;
    
    // 设置导航栏的背景颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // 给导航栏添加背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"luckcoffee.JPG"] forBarMetrics:UIBarMetricsDefault];
    
    // 获取选中的TabBar
    UINavigationController *navigationController =  (UINavigationController *)self.parentViewController;
    NSString *selectTab = navigationController.tabBarItem.title;
    NSLog(@"选中的TabBar标题为：%@",selectTab);
}


@end
