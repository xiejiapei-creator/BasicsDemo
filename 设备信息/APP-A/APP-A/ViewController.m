//
//  ViewController.m
//  APP-A
//
//  Created by 谢佳培 on 2020/9/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, assign) BOOL isBack;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"App-A";
    self.isBack = YES;
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(50, 300, 300, 80)];
    button.backgroundColor = [UIColor blackColor];
    [button setTitle:@"点击跳转到App-B" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(jumpToAppB) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton * writerButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 400, 300, 80)];
    writerButton.backgroundColor = [UIColor blackColor];
    [writerButton setTitle:@"点击跳转到App-B的作家页面" forState:UIControlStateNormal];
    [writerButton addTarget:self action:@selector(jumpToAppBWriterViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:writerButton];
    
    UIButton * wasteMaterialsButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 500, 300, 80)];
    wasteMaterialsButton.backgroundColor = [UIColor blackColor];
    [wasteMaterialsButton setTitle:@"点击跳转到App-B的废材页面" forState:UIControlStateNormal];
    [wasteMaterialsButton addTarget:self action:@selector(jumpToAppBWasteMaterialsViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wasteMaterialsButton];
}

- (void)jumpToAppB
{
    // 1.获取应用程序App-B的URL Scheme
    NSURL *appBUrl = [NSURL URLWithString:@"AppB://?AppA"];
    
    // 2.判断手机中是否安装了对应程序并跳转
    if ([[UIApplication sharedApplication] canOpenURL:appBUrl])
    {
        [[UIApplication sharedApplication] openURL:appBUrl options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:^(BOOL success) {

            if (!success)
            {

                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"不能完成跳转" message:@"请确认App已经安装" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                [self  presentViewController:alertController animated:YES completion:nil];
            }
            else if(self.isBack)
            {
                // [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    else
    {
        NSLog(@"没有安装");
    }
}

- (void)jumpToAppBWriterViewController
{
    // 1.获取应用程序App-B的Page1页面的URL
    NSURL *appBUrl = [NSURL URLWithString:@"AppB://WriterViewController?AppA"];

    // 2.判断手机中是否安装了对应程序并跳转
    if ([[UIApplication sharedApplication] canOpenURL:appBUrl])
    {
        [[UIApplication sharedApplication] openURL:appBUrl options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:^(BOOL success) {

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

- (void)jumpToAppBWasteMaterialsViewController
{
    // 1.获取应用程序App-B的Page1页面的URL
    NSURL *appBUrl = [NSURL URLWithString:@"AppB://WasteMaterialsViewController?AppA"];

    // 2.判断手机中是否安装了对应程序并跳转
    if ([[UIApplication sharedApplication] canOpenURL:appBUrl])
    {
        [[UIApplication sharedApplication] openURL:appBUrl options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:^(BOOL success) {

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
