//
//  WriterViewController.m
//  APP-B
//
//  Created by 谢佳培 on 2020/9/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "WriterViewController.h"

@interface WriterViewController ()

@property(nonatomic, assign) BOOL isBack;

@end

@implementation WriterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"作家";
    self.view.backgroundColor = [UIColor whiteColor];
    self.isBack = NO;
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(50, 400, 300, 80)];
    button.backgroundColor = [UIColor blackColor];
    [button setTitle:@"跳转回App-A" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToAppA) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)backToAppA
{
    // 1.拿到对应应用程序的URL Scheme
    NSString *urlSchemeString = [[self.urlString componentsSeparatedByString:@"?"] lastObject];
    NSString *urlString = [urlSchemeString stringByAppendingString:@"://"];
    
    // 2.获取对应应用程序的URL
    NSURL *appAUrl = [NSURL URLWithString:urlString];
    
    // 3.判断是否可以打开
    if (appAUrl && [[UIApplication sharedApplication] canOpenURL:appAUrl])
    {
        [[UIApplication sharedApplication] openURL:appAUrl options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:^(BOOL success) {

            if (!success)
            {

                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"不能完成跳转" message:@"请确认App已经安装" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                [self  presentViewController:alertController animated:YES completion:nil];
            }
            else if(self.isBack)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    else
    {
        NSLog(@"没有安装");
    }
}

@end
