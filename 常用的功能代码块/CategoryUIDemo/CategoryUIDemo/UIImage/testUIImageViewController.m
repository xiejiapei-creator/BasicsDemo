//
//  testUIImageViewController.m
//  CategoryDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import "testUIImageViewController.h"
#import "UIImage+Custom.h"

@interface testUIImageViewController ()

@end

@implementation testUIImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createImageByColor];
}

// 通过颜色来生成图片
- (void)createImageByColor
{
    UIImage *backImage = [UIImage imageWithColor:[UIColor blueColor]];
    [self.navigationController.navigationBar setBackgroundImage:backImage forBarMetrics:UIBarMetricsDefault];
}

@end
