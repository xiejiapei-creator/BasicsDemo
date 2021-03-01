//
//  testUIImageViewController.m
//  CategoryDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import "testUIImageViewController.h"
#import "UIImage+Custom.h"
#import "ImageTool.h"

@interface testUIImageViewController ()

@property(nonatomic, strong) UIImageView *imageView;

@end

@implementation testUIImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self useWaterImage];
}

// 通过颜色来生成图片
- (void)createImageByColor
{
    UIImage *backImage = [UIImage imageWithColor:[UIColor blueColor]];
    [self.navigationController.navigationBar setBackgroundImage:backImage forBarMetrics:UIBarMetricsDefault];
}

- (void)useWaterImage
{
    // 原图
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, 300, 200)];
    self.imageView.image = [UIImage imageNamed:@"backImage"];
    [self.view addSubview:self.imageView];
    
    // 模糊图片
    UIImage *filterImage = [ImageTool filterImage:nil];
    
    // 文字水印
    UIImageView *textImageView = [[UIImageView alloc] initWithImage:[ImageTool WaterImageWithText:@"谢佳培" backImage:filterImage]];
    textImageView.frame = CGRectMake(20, 320, 300, 200);
    [self.view addSubview:textImageView];
    
    // Logo水印
    UIImage *logoImage = [UIImage imageNamed:@"icon"];
    UIImageView *waterImageView = [[UIImageView alloc] initWithImage:[ImageTool WaterImageWithWaterImage:logoImage backImage:nil waterImageRect:CGRectMake(20, 540, 100, 40)]];
    waterImageView.frame = CGRectMake(20, 520, 300, 200);
    [self.view addSubview:waterImageView];
}

@end
